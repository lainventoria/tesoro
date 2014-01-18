class Factura < ActiveRecord::Base

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
