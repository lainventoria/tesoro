# encoding: utf-8
class UnidadFuncional < ActiveRecord::Base
  belongs_to :obra
  validates_presence_of :tipo, :obra_id, :precio_venta

  monetize :precio_venta_centavos, with_model_currency: :precio_venta_moneda
end
