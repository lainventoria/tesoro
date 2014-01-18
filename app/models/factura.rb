class Factura < ActiveRecord::Base
  # Las facturas se pueden cancelar con muchos recibos
  has_many :recibos

  # Las situaciones posibles en que se genera una factura
  SITUACIONES = %w(cobro pago)
  # Sólo aceptamos esas :3
  validates_inclusion_of :situacion, in: SITUACIONES

  monetize :importe_total_centavos

  # Chequea si la situación es pago
  def pago?
    situacion == 'pago'
  end

  # Chequea si la situación es cobro
  def cobro?
    situacion == 'cobro'
  end

  # La factura está cancelada cuando la suma del monto de los recibos es
  # igual al monto original
  def cancelada?
    saldo == importe_total
  end

  # Cuánto se adeuda de esta factura en base a todos los recibos
  def saldo
    # Obviamente esto no va a andar
    # TODO encontrar la agregación de moneda
    importe_total - Money.new(recibos.sum(:importe_moneda))
  end
end
