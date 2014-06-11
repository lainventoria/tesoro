# encoding: utf-8
class UnidadFuncional < ActiveRecord::Base
  belongs_to :obra
  belongs_to :contrato_de_venta
  validates_presence_of :tipo, :obra_id, :precio_venta

  before_destroy :chequear_no_se_usa

  monetize :precio_venta_centavos, with_model_currency: :precio_venta_moneda

  def precio_venta(moneda = 'ARS')
    Money.new(precio_venta_centavos, moneda)
  end

  protected
    def chequear_no_se_usa
      unless contrato_de_venta.count() == 0 
        errors.add_to_base "La unidad funcional no puede tener contratos de venta al momento de borrarse."
      end
    end

end
