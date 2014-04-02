# encoding: utf-8
# La Oficina Central es agente de retención de la AFIP. Retiene tanto Impuesto
# a las Ganancias como Cargas Sociales. Las retenciones las determina el
# contador, potencialmente cada factura tiene una retención asociada que sirve
# como medio de pago de la misma
class Retencion < ActiveRecord::Base
  include MedioDePago

  # La factura sobre la que se hace la retención
  belongs_to :factura
  has_one :obra, through: :factura
  has_one :tercero, through: :factura
  has_many :recibos, through: :movimientos

  # Las retenciones se pagan desde una cuenta
  belongs_to :cuenta, ->{ where(situacion: 'banco') },
    class_name: 'Caja'
  # Técnicamente no es una chequera pero por ahora es lo mismo
  belongs_to :caja_afip, ->{ where(situacion: 'chequera') },
    class_name: 'Caja'

  validates_presence_of :factura
  validate :factura_es_un_pago

  # Sólo PDFs
  has_attached_file :documento
  validates_attachment_content_type :documento, content_type: /\Aapplication\/pdf\Z/

  monetize :monto_centavos, with_model_currency: :monto_moneda

  # Usar esta retención como medio de pago. La asociamos como causa del movimiento
  # de extracción de la AFIP (deuda con ellos), y asociamos el recibo de pago
  # al movimiento.
  def usar_para_pagar(este_recibo)
    if movimiento = caja_afip.extraer(monto)
      movimiento.causa = self
      movimiento.recibo = este_recibo
      movimiento
    else
      false
    end
  end

  private

    def factura_es_un_pago
      errors.add :factura, :debe_ser_un_pago unless factura.pago?
    end
end
