module ChequesHelper

  def titulo_vista_cheque
    if :propio?
      "Detalles de Cheque Propio"
    else
      "Detalles de Cheque de Tercero"
    end
  end 

  def titulo_listado_cheques
    if @situacion == 'propios'
      "Listado de Cheques Propios"
    else
      "Listado de Cheques de Terceros"
    end
  end

  def path_a_listado
    if :propio?
      propios_cheques_path
    else
      terceros_cheques_path
    end
  end

  def path_a_recibo
    recibo_path(:recibo)
  end

end
