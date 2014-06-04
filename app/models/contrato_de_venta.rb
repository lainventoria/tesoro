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

  def hacer_pago_inicial(monto)
    crear_cuota(descripcion: 'Pago inicial', vencimiento: fecha, monto_original: monto)
  end
end
