module CajasHelper

  def saldo_movimientos (caja_id)
    @movs = Movimiento.where(caja_id: caja_id)
    if @movs.empty?
      saldo = 0
    else
      saldo = @movs.monto.sum 
    end
  end

  def valor_situacion
    if @caja.new_record? 
      params[:situacion]
    else
      @caja.situacion
    end
  end

end
