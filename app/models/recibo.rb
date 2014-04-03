# encoding: utf-8
class Recibo < ActiveRecord::Base
  # Las facturas se cancelan con uno o más recibos
  belongs_to :factura, inverse_of: :recibos
  has_one :obra, through: :factura
  has_one :tercero, through: :factura

  # Los recibos disparan movimientos
  has_many :movimientos, inverse_of: :recibo, dependent: :restrict_with_error
  # Por eso cada recibo tiene que estar asociado a una factura
  # a menos que sea un recibo interno (burocracia!)
  validates_presence_of :factura, unless: :interno?
  validate :importe_no_supera_el_saldo, unless: :interno?

  before_save :actualizar_situacion, unless: :interno?

  # Todas las situaciones en que se generan recibos
  SITUACIONES = %w(cobro pago interno)
  validates_inclusion_of :situacion, in: SITUACIONES

  # Crear un recibo interno para una transacción específica
  # TODO pasar a build?
  def self.interno_nuevo
    create(situacion: 'interno', fecha: Time.now)
  end

  # Es un recibo de pago?
  def pago?
    situacion == 'pago'
  end

  # Es un recibo de cobro?
  def cobro?
    situacion == 'cobro'
  end

  def interno?
    situacion == 'interno'
  end

  def actualizar_situacion
    self.situacion = factura.situacion
  end

  def pagar_con(medio_de_pago)
    if medio_de_pago.present?
      if pago = medio_de_pago.usar_para_pagar(self)
        # TODO no haría falta si cada usar para pagar lo hace? o mejor, no paso
        # el recibo y ya
        movimientos.build caja: pago.caja, monto: pago.monto, causa: pago.causa
        save
      else
        false
      end
    else
      true # noop, como un save sin cambios
    end
  end

  # Calcula el importe del recibo en base a los movimientos existentes. Si el
  # recibo es de pago, los movimientos son de salida, asique los convertimos a
  # positivo
  def importe
    movimientos.collect(&:monto).sum.to_money(importe_moneda).abs
  end

  # El la moneda del importe de este recibo siempre va a ser la misma que su
  # factura
  def importe_moneda
    factura.try :importe_total_moneda
  end

  private

    def importe_no_supera_el_saldo
      if factura.present?
        errors.add :movimientos, :sobrepasan_el_saldo if importe_temporal > factura.saldo
      end
    end

    # recibo.importe devuelve la suma existente en la db (al ser llamado durante
    # las validaciones), que ya está restando del saldo, asique seleccionamos
    # sólo los movimientos nuevos
    def importe_temporal
      movimientos.select(&:new_record?).collect(&:monto).sum.to_money(importe_moneda).abs
    end
end
