class Recibo < ActiveRecord::Base
  belongs_to :factura

  SITUACIONES = %w(cobro pago)

  monetize :importe_centavos
  validates_inclusion_of :situacion, in: SITUACIONES

  def pago?
    situacion == 'pago'
  end

  def cobro?
    situacion == 'cobro'
  end
end
