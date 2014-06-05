# encoding: utf-8
class ContratoDeVenta < ActiveRecord::Base
  belongs_to  :indice
  belongs_to  :tercero
  belongs_to :obra

  has_many :cuotas

  validates_presence_of :indice_id, :tercero_id, :monto_total_centavos, :obra_id

  monetize :monto_total_centavos, with_model_currency: :monto_total_moneda

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
    resto = monto_a_financiar % cantidad
    monto_por_cuota = monto_a_financiar / cantidad

    # crear las cuotas mensuales
    Cuota.transaction do
      cantidad.times { |cuota|
        cuota+=1
        crear_cuota(monto_original: monto_por_cuota,
          vencimiento: fecha + cuota.months,
          descripcion: "Cuota ##{cuota}")
      }

      # sumarle el resto a la primera cuota
      if resto > 0
        cuotas.second.monto_original += Money.new(resto)
        cuotas.second.save
      end
    end

  end
end
