# encoding: utf-8
class UnidadFuncional < ActiveRecord::Base
  belongs_to :obra
  belongs_to :contrato_de_venta
  has_one :tercero, through: :contrato_de_venta

  # Los tipos que puede tener una unidad funcional
  # FIXME no es demasiado hardcodeo esto?
  TIPOS = %w(Departamento Cochera Baulera)

  # Validaciones
  validates_inclusion_of :tipo, in: TIPOS
  validates_presence_of :tipo, :obra_id, :precio_venta
  validate :vender_con_precio_de_venta_final

  before_destroy :chequear_que_no_se_use

  monetize :precio_venta_centavos, with_model_currency: :precio_venta_moneda
  monetize :precio_venta_final_centavos, with_model_currency: :precio_venta_final_moneda

  scope :disponibles, -> { where(contrato_de_venta: nil) }
  scope :vendidas, -> { where.not(contrato_de_venta: nil) }
  scope :departamentos, -> { where(tipo: 'Departamento') }
  scope :cocheras, -> { where(tipo: 'Cochera') }
  scope :bauleras, -> { where(tipo: 'Baulera') }

  def disponible?
    self.contrato_de_venta.nil?
  end

  def para_mostrar
    "#{self.tipo} - #{self.descripcion}"
  end

  protected

    def chequear_que_no_se_use
      errors.add :no_debe_tener_contratos if self.contrato_de_venta.present?
    end

    def vender_con_precio_de_venta_final
      return unless contrato_de_venta.present?

      errors.add(:contrato_de_venta, :no_se_definio_precio_de_venta_final) if precio_venta_final.nil?
    end
end
