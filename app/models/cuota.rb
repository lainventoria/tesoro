# encoding: utf-8
class Cuota < ActiveRecord::Base
  belongs_to :contrato_de_venta

  monetize :monto_original_centavos, with_model_currency: :monto_original_moneda

  validates_numericality_of :monto_original_centavos, greater_than: 0
  validates_presence_of :vencimiento, :descripcion

  # el monto actualizado es el monto original por el proporcional del
  # indice actual y el indice original
  def monto_actualizado
    monto_original * ( indice_actual.valor / contrato_de_venta.indice.valor )
  end

  # obtiene el indice actual según el indice del contrato y el
  # vencimiento
  def indice_actual
    # TODO esperando respuesta en #215 para afinar esto
    Indice.where(periodo: vencimiento).where(denominacion: contrato_de_venta.indice.denominacion).first
  end
end

