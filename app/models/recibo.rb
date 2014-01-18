class Recibo < ActiveRecord::Base
  belongs_to :factura
  monetize :importe_centavos, as: 'importe'
end
