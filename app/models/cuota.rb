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

  # mostrar todas las cuotas vencidas
  # que no sean el pago inicial porque es como la cuota 0
  scope :vencidas, lambda { |time = nil|
    time = Time.now if not time
    where.not(descripcion: "Pago inicial").where("vencimiento < ?", time)
  }

  def vencida?(time = nil)
    time = Time.now if not time

    vencimiento < time
  end

  # el monto actualizado es el monto original por el proporcional del
  # indice actual y el indice original
  def monto_actualizado(periodo = nil)
    monto_original * ( indice_actual(periodo).valor / contrato_de_venta.indice.valor )
  end

  # obtiene el indice actual según el indice del contrato y el
  # vencimiento o una fecha especificada
  def indice_actual(periodo = nil)
    periodo = vencimiento - 1.month if periodo.nil?
    Indice.where(periodo: periodo).where(denominacion: contrato_de_venta.indice.denominacion).first
  end

  # pagar la cuota genera una factura de cobro que el tercero adeuda
  def generar_factura(periodo = nil)
    # si la cuota se paga antes de tiempo, el monto actualizado se
    # calcula al indice del mes actual en lugar del indice del mes de
    # vencimiento
    unless vencida?
      # los periodos comienzan con el mes
      periodo = Time.now.change(sec: 0, min: 0, hour: 0, day: 1).to_date - 1.month if periodo.nil?
      vencimiento = Time.now
    end

    Factura.transaction do
      # FIXME faltan tipo y número
      self.factura = Factura.new(situacion: 'cobro',
        importe_neto: monto_actualizado(periodo),
        fecha: vencimiento,
        descripcion: descripcion,
        tercero: tercero,
        obra: obra)

      self.save

    end
  end
end

