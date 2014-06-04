# encoding: utf-8
class ContratoDeVenta < ActiveRecord::Base
  has_one  :indice
  has_one  :tercero
  has_many :cuotas

  validates_presence_of :indice_id, :tercero_id, :monto_total_centavos

  monetize :monto_total_centavos, with_model_currency: :monto_total_moneda
end
