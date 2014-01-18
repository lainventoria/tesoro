class Recibo < ActiveRecord::Base
  belongs_to :factura

  situacion = %w(emitido recibido)

  monetize :importe_centavos
  validates_inclusion_of :emitido_o_recibido, in: situacion

  def recibido?
    True if :emitido_o_recibido == 'recibido'
  end

  def emitido?
    True if :emitido_o_recibido == 'emitido'
  end
end
