# encoding: utf-8
class Cuota < ActiveRecord::Base
  belongs_to :contrato_de_venta
  belongs_to :factura
  belongs_to :indice
  has_one :tercero, through: :contrato_de_venta
  has_one :obra, through: :contrato_de_venta

  monetize :monto_original_centavos, with_model_currency: :monto_original_moneda

  validates_numericality_of :monto_original_centavos, greater_than: 0
  validates_presence_of :vencimiento, :descripcion

  # cuotas con facturas emitidas
  scope :emitidas, -> { where.not(factura: nil) }
  # cuotas sin factura emitida
  scope :pendientes, -> { where(factura: nil) }

  # mostrar todas las cuotas vencidas
  # que no sean el pago inicial porque es como la cuota 0
  def self.vencidas(time = nil)
    # FIXME no habíamos sacado este not irrelevante?
    where.not(descripcion: 'Pago inicial').where('vencimiento < ?', time || Time.now)
  end

  def self.sin_vencer(time = nil)
    where('vencimiento > ?', time || Time.now)
  end

  def vencida?(time = nil)
    vencimiento < (time || Time.now)
  end

  # el monto actualizado es el monto original por el proporcional del
  # indice actual y el indice original
  def monto_actualizado(periodo = nil)
    monto_original * (indice_actual(periodo).valor / contrato_de_venta.indice.valor)
  end

  # obtiene el indice actual según el indice del contrato y el
  # vencimiento o una fecha especificada y luego cachea.
  #
  # si el indice no existe se crea uno temporal
  #
  def indice_actual(periodo = nil)
    # calcular el periodo si no lo especificamos
    periodo = contrato_de_venta.periodo_para(vencimiento) if periodo.nil?

    # devuelve el mejor indice del momento y se queda con ese
    self.indice = Indice.por_fecha_y_denominacion(periodo, contrato_de_venta.indice.denominacion) if indice.nil?

    indice
  end

  # pagar la cuota genera una factura de cobro que el tercero adeuda
  def generar_factura(periodo = nil)
    vencimiento_actual = self.vencimiento
    # si la cuota se paga antes de tiempo, el monto actualizado se
    # calcula al indice del mes actual en lugar del indice del mes de
    # vencimiento
    unless vencida?
      periodo = contrato_de_venta.periodo_para(Date.today)
      vencimiento_actual = Date.today
    end

    Factura.transaction do
      # FIXME falta el número
      self.factura = Factura.new(situacion: 'cobro',
        importe_neto: monto_actualizado(periodo),
        fecha: vencimiento_actual,
        fecha_pago: vencimiento_actual + 10.days,
        descripcion: descripcion,
        tipo: contrato_de_venta.tipo_factura,
        tercero: tercero,
        obra: obra)
      self.save
      self.factura
    end
  end
end
