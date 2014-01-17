class Factura < ActiveRecord::Base
  monetize :importe_total_centavos, as: 'importe_total'
end
