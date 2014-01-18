class Factura < ActiveRecord::Base
  monetize :importe_total_centavos
  validates_inclusion_of :emitida_o_recibida, in: %w(emitida recibida)

  def recibida?
    True if :emitida_o_recibida == 'recibido'
  end

  def emitida?
    True if :emitida_o_recibida == 'emitido'
  end
end
