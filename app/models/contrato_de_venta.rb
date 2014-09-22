# encoding: utf-8
# Un Contrato de venta es un grupo de Unidades funcionales vendidas a un
# Tercero
class ContratoDeVenta < ActiveRecord::Base
  RELACIONES_INDICE = %w{anterior actual}

  belongs_to :indice
  belongs_to :tercero
  belongs_to :obra

  has_many :cuotas, dependent: :destroy
  # no toma la inflexión en la asociación
  has_many :unidades_funcionales, class_name: 'UnidadFuncional', dependent: :nullify

  validates_presence_of :indice_id, :tercero_id, :obra_id,
    :unidades_funcionales, :relacion_indice, :fecha
  validates_numericality_of :monto_total_centavos, greater_than_or_equal_to: 0
  validates_inclusion_of :relacion_indice, in: RELACIONES_INDICE
  validate :unidades_funcionales_en_la_misma_moneda, :cuotas_en_la_misma_moneda,
    :tercero_es_cliente, :total_de_cuotas_es_igual_al_monto_total,
    :todo_en_la_misma_moneda

  before_validation :calcular_monto_total

  accepts_nested_attributes_for :tercero

  monetize :monto_total_centavos, with_model_currency: :monto_total_moneda

  normalize_attribute :tipo_factura, with: [ :strip, :blank, { truncate: { length: 1 } }, :upcase ]

  # crea una cuota con un monto específico
  def crear_cuota(attributes = {})
    cuotas.create(attributes)
  end

  # agrega una cuota con un monto específico
  def agregar_cuota(attributes = {})
    cuota = Cuota.new(attributes)
    self.cuotas << cuota
  end

  # crea un pago inicial
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
    Money.new(cuotas.collect(&:monto_original_centavos).sum, cuotas.first.monto_original_moneda)
  end

  def total_de_unidades_funcionales
    monto = unidades_funcionales.collect do |u|
      if u.precio_venta_final_centavos > 0
        u.precio_venta_final_centavos
      else
        u.precio_venta_centavos
      end
    end.sum

    Money.new(monto, unidades_funcionales.first.precio_venta_final_moneda)
  end

  def periodo_para(fecha)
    (relacion_indice == 'anterior' ? fecha.last_month : fecha).beginning_of_month
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

    def total_de_cuotas_es_igual_al_monto_total
      # solo validar cuotas cuando las hay
      if !cuotas.empty? && total_de_cuotas != monto_total
        errors.add(:cuotas, :total_igual_a_monto_total)
      end
    end

    def tercero_es_cliente
      errors.add(:tercero, :debe_ser_cliente) unless tercero.cliente?
    end

    def unidades_funcionales_en_la_misma_moneda
      if unidades_funcionales.collect(&:precio_venta_final_moneda).uniq.count > 1
        errors.add(:unidades_funcionales, :debe_ser_la_misma_moneda)
      end
    end

    def cuotas_en_la_misma_moneda
      if cuotas.collect(&:monto_original_moneda).uniq.count > 1
        errors.add(:cuotas, :debe_ser_la_misma_moneda)
      end
    end

    # Valida que las cuotas estén en la misma moneda que las unidades
    # funcionales
    def todo_en_la_misma_moneda
      # no hace falta si no hay cuotas
      return unless cuotas.any?

      # usamos la primera porque ya validamos que estén todas en la
      # misma moneda
      if unidades_funcionales.first.precio_venta_final_moneda !=
         cuotas.first.monto_original_moneda

         errors.add(:base, :todo_en_la_misma_moneda)
      end
    end
end
