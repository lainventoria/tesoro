class Recibo < ActiveRecord::Base
  belongs_to :factura

  monetize :importe_centavos
end
