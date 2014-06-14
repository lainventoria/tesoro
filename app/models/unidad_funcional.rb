# encoding: utf-8
class UnidadFuncional < ActiveRecord::Base
  belongs_to :obra
  belongs_to :contrato_de_venta
  has_one :tercero, through: :contrato_de_venta

  # Los tipos que puede tener una unidad funcional
  TIPOS = %w(Departamento Cochera Baulera)

  # Validaciones
  validates_inclusion_of :tipo, in: TIPOS
  validates_presence_of :tipo, :obra_id, :precio_venta

  before_destroy :chequear_no_se_usa

  monetize :precio_venta_centavos, with_model_currency: :precio_venta_moneda

  def precio_venta(moneda = 'ARS')
    Money.new(precio_venta_centavos, moneda)
  end

  protected
    def chequear_no_se_usa
      if self.contrato_de_venta.present?
        errors.add :no_debe_tener_contratos
      end
    end

end
