class Recibo < ActiveRecord::Base
  belongs_to :factura

  situacion = %w(emitido recibido)

  monetize :importe_centavos
  validates_inclusion_of :emitido_o_recibido, in: situacion

  def recibido?
    emitido_o_recibido == 'recibido'
  end

  def emitido?
    emitido_o_recibido == 'emitido'
  end
end
