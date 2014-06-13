# encoding: utf-8
# Un Contrato de venta es un grupo de Unidades funcionales vendidas a un
# Tercero
class ContratoDeVenta < ActiveRecord::Base
  belongs_to :indice
  belongs_to :tercero
  belongs_to :obra

  has_many :cuotas
  # no toma la inflexión en la asociación
  has_many :unidades_funcionales, class_name: 'UnidadFuncional'

  validates_presence_of :indice_id, :tercero_id, :obra_id, :unidades_funcionales
  validates_numericality_of :monto_total_centavos, greater_than_or_equal_to: 0

  before_validation :calcular_monto_total, :validar_cliente,
    :validar_total_de_cuotas, :validar_monedas

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
    self.cuotas.create(attributes)
  end

  # crea un pago inicial con la fecha de vencimiento igual a la fecha
  # del contrato
  # TODO chequear que sea el único?
  def hacer_pago_inicial(monto)
    crear_cuota(descripcion: 'Pago inicial', vencimiento: fecha, monto_original: monto)
  end

  # divide el monto total menos el pago inicial en partes iguales
  def crear_cuotas(cantidad)
    # antes hay que hacer un pago inicial
    return false if cuotas.empty?

    monto_a_financiar = monto_total - cuotas.first.monto_original
    # esto va a sobrar de la división y se lo mandamos a la primera
    # cuota
    monto_por_cuota = monto_a_financiar / cantidad
    resto = monto_a_financiar - (monto_por_cuota * cantidad)

    # crear las cuotas mensuales
    Cuota.transaction do
      cantidad.times { |cuota|
        cuota+=1
        crear_cuota(monto_original: monto_por_cuota,
          vencimiento: fecha + cuota.months,
          descripcion: "Cuota ##{cuota}")
      }

      # sumarle el resto a la primera cuota
      cuotas.second.monto_original += resto
      cuotas.second.save
    end

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
    Money.new(unidades_funcionales.collect(&:precio_venta_centavos).sum,
      moneda?)
  end
 
  # setear magicamente el tercero si no pasamos uno existente
  def tercero_attributes=(attributes = {})
    if tercero_id.nil?
      self.tercero = Tercero.where(attributes.merge({ relacion: 'ambos' })).first_or_create
    end
  end
 
  # setear magicamente el tercero si no pasamos uno existente
  def tercero_attributes=(attributes = {})
    if tercero_id.nil?
      self.tercero = Tercero.where(attributes.merge({ relacion: 'ambos' })).first_or_create
    end
  end
 
  # setear magicamente el tercero si no pasamos uno existente
  def tercero_attributes=(attributes = {})
    if tercero_id.nil?
      self.tercero = Tercero.where(attributes.merge({ relacion: 'ambos' })).first_or_create
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
      if monedas?.count > 1
        errors.add(:unidades_funcionales, :debe_ser_la_misma_moneda)
      end

      if cuotas.collect(&:monto_original_moneda).uniq.count > 1
        errors.add(:cuotas, :debe_ser_la_misma_moneda)
      end
    end
   
end
