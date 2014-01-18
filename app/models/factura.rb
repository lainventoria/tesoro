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
end
