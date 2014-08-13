# encoding: utf-8
# Un Contrato de venta es un grupo de Unidades funcionales vendidas a un
# Tercero
class ContratoDeVenta < ActiveRecord::Base
  belongs_to :indice
  belongs_to :tercero
  belongs_to :obra

  has_many :cuotas, dependent: :destroy
  # no toma la inflexión en la asociación
  has_many :unidades_funcionales, class_name: 'UnidadFuncional', dependent: :nullify

  validates_presence_of :indice_id, :tercero_id, :obra_id, :unidades_funcionales, :relacion_indice
  validates_numericality_of :monto_total_centavos, greater_than_or_equal_to: 0

  before_validation :validar_monedas, :calcular_monto_total,
    :validar_cliente, :validar_total_de_cuotas

  monetize :monto_total_centavos, with_model_currency: :monto_total_moneda

  def monedas?
    unidades_funcionales.collect(&:precio_venta_moneda).uniq
  end

  def moneda?
    monedas?.first
  end
  accepts_nested_attributes_for :tercero

  # crea una cuota con un monto específico
  def crear_cuota(attributes = {})
    cuotas.create(attributes)
  end

  # agrega una cuota con un monto específico
  def agregar_cuota(attributes = {})
    cuota = Cuota.new(attributes)
    self.cuotas << cuota
  end

  # crea un pago inicial con la fecha de vencimiento igual a la fecha
  # del contrato
  # TODO chequear que sea el único?
  def agregar_pago_inicial(fecha, monto)
    agregar_cuota(descripcion: 'Pago inicial', vencimiento: fecha, monto_original: monto)
  end

  # por cada unidad funcional que se agrega se recalcula el monto
  def agregar_unidad_funcional(unidad_funcional)
    unidad_funcional.contrato_de_venta = self
    self.unidades_funcionales << unidad_funcional
    calcular_monto_total
  end

  def quitar_unidad_funcional(unidad_funcional)
    unidad_funcional.contrato_de_venta = nil
    self.unidades_funcionales.delete unidad_funcional
    calcular_monto_total
  end

  def total_de_cuotas
    Money.new(cuotas.collect(&:monto_original_centavos).sum, moneda?)
  end

  def total_de_unidades_funcionales
    Money.new(unidades_funcionales.collect do |u|
        if u.precio_venta_final_centavos > 0
          u.precio_venta_final_centavos
        else
          u.precio_venta_centavos
        end
      end.sum,
      moneda?)
  end

  def periodo_para(fecha)
    periodo = fecha.beginning_of_month()
    periodo = periodo - 1.months if relacion_indice == 'anterior'
  end

  def indice_para(fecha)
    Indice.por_fecha_y_denominacion(periodo_para(fecha), 'Costo de construcción')
  end

  # setear magicamente el tercero si no pasamos uno existente
  def tercero_attributes=(attributes = {})
    if tercero_id.nil?
      self.tercero = Tercero.find_or_create_by(cuit: attributes[:cuit]) do |tercero|
        if tercero.persisted?
          tercero.volverse_cliente
          self.tercero_id = tercero
        else
          tercero.nombre = attributes[:nombre]
          tercero.relacion = 'cliente'
        end
      end
    end
  end

  private

    # El monto original es la suma de los valores de venta de las
    # unidades funcionales
    def calcular_monto_total
      self.monto_total = total_de_unidades_funcionales
    end

    def validar_total_de_cuotas
      # solo validar cuotas cuando las hay
      if !cuotas.empty? && total_de_cuotas != monto_total
        errors.add(:cuotas, :total_igual_a_monto_total)
      end
    end

    def validar_cliente
      errors.add(:tercero, :debe_ser_cliente) if !tercero.cliente?
    end

    def validar_monedas
      if unidades_funcionales.collect(&:precio_venta_final_moneda).uniq.count > 1
        errors.add(:unidades_funcionales, :debe_ser_la_misma_moneda)
      end

      if cuotas.collect(&:monto_original_moneda).uniq.count > 1
        errors.add(:cuotas, :debe_ser_la_misma_moneda)
      end
    end

end
