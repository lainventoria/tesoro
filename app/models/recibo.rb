class Recibo < ActiveRecord::Base
  # Las facturas se cancelan con uno o más recibos
  belongs_to :factura

  # Todas las situaciones en que se generan recibos
  SITUACIONES = %w(cobro pago)
  validates_inclusion_of :situacion, in: SITUACIONES

  monetize :importe_centavos

  # Es un recibo de pago?
  def pago?
    situacion == 'pago'
  end

  # Es un recibo de cobro?
  def cobro?
    situacion == 'cobro'
  end
end
