# encoding: utf-8
class Cuota < ActiveRecord::Base
  monetize :monto_original_centavos, with_model_currency: :monto_original_moneda

  validates_numericality_of :monto_original_centavos, greater_than: 0
  validates_presence_of :vencimiento
  validates_presence_of :descripcion
end

