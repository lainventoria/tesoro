# encoding: utf-8
# Representa la interfaz que debe proveer cualquier objeto que sirva como causa
# de un movimiento en el sistema
module CausaDeMovimientos
  extend ActiveSupport::Concern

  included do
    # Cada medio de pago tiene movimientos, de los cuales es la causa
    has_many :movimientos, as: :causa
  end

  # Cada medio de pago tiene que implementar su propio proceso de pago
  def usar_para_pagar(recibo)
    raise NotImplementedError, 'Cada medio de pago debe definir `usar_para_pagar`'
  end
end
