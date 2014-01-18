class Factura < ActiveRecord::Base

  situacion = %w(emitida recibida)

  monetize :importe_total_centavos
  validates_inclusion_of :emitida_o_recibida, in: situacion

  def recibida?
    True if :emitida_o_recibida == 'recibida'
  end

  def emitida?
    True if :emitida_o_recibida == 'emitida'
  end
end
