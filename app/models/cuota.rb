# encoding: utf-8
class Cuota < ActiveRecord::Base
  monetize :monto_original_centavos, with_model_currency: :monto_original_moneda
end

