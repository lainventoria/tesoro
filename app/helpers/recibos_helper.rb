module RecibosHelper
  def recibos_por_tipo_path
    if @recibo.pago?
      pagos_recibos_path
    else
      cobros_recibos_path
    end
  end

  def link_a_causa(movimiento)
    case movimiento.causa_type
      when 'Efectivo', 'Transferencia'
        movimiento.causa_type
      else
        link_to(movimiento.causa)
    end
  end

  def link_a_nuevo_movimiento(causa)
    link_to causa, new_causa_path(causa: { tipo: causa.parameterize }, obra_id: @recibo.obra),
      data: { remote: true }, class: 'agregar-movimiento'
  end
end
