# encoding: utf-8
class Efectivo < PagoNoTrackeable
  include MedioDePago

  def usar_para_pagar(recibo)
    if movimiento = caja.extraer(monto)
      movimiento.causa = self
      movimiento.recibo = recibo
      movimiento
    else
      false
    end
  end
end
