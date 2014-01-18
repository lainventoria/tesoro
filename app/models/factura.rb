class Factura < ActiveRecord::Base
  has_many :recibos

  SITUACIONES = %w(cobro pago)

  monetize :importe_total_centavos
  validates_inclusion_of :situacion, in: SITUACIONES

  def pago?
    situacion == 'pago'
  end

  def cobro?
    situacion == 'cobro'
  end
end
