# encoding: utf-8
class Transferencia < PagoNoTrackeable
  include CausaDeMovimientos

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
