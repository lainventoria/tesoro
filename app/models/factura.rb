class Factura < ActiveRecord::Base
  monetize :importe_total_centavos
end
