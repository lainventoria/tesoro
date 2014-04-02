# encoding: utf-8
class Efectivo < PagoNoTrackeable
  include CausaDeMovimientos

  validates_presence_of :monto, :caja
  validate :caja_es_de_efectivo

  def usar_para_pagar(recibo)
    if movimiento = caja.extraer(monto)
      movimiento.causa = self
      movimiento.recibo = recibo
      movimiento
    else
      false
    end
  end

  private

    def caja_es_de_efectivo
      errors.add(:caja, :debe_ser_de_efectivo) unless caja.efectivo?
    end
end
