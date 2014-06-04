# encoding: utf-8
class ContratoDeVenta < ActiveRecord::Base
  belongs_to  :indice
  belongs_to  :tercero
  belongs_to :obra

  has_many :cuotas

  validates_presence_of :indice_id, :tercero_id, :monto_total_centavos, :obra_id

  monetize :monto_total_centavos, with_model_currency: :monto_total_moneda
end
