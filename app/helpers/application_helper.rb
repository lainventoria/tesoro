module ApplicationHelper
  # Título de la página para el +<head>+ por defecto
  def titulo_de_la_aplicacion
    "#{titulo.present? ? "#{titulo} | " : nil}Tesoro"
  end

  # Por defecto, no se usa nada. Cada helper específico redefine este método si
  # quiere un título específico
  def titulo
    nil
  end

	def formatted_date(date)
    date.nil? ? '' : date.strftime('%d %b %Y')
	end

  # habilita la edicion de los formularios segun el valor de @editar
  def editar_o_bloquear
    if ! @editar
      'disabled'
    end
  end

  # formatear un valor absoluto con separador de miles y mostrar en rojo
  # si es negativo, opcionalmente mostrando la moneda
  def formatted_number(numero, moneda = nil)
    content_tag :span, class: negativo_rojo(numero) do
      number_to_currency(numero.to_f,
        delimiter: '.',
        separator: ',',
        format: '%n %u&nbsp;'.html_safe,
        unit: (moneda || ''),
        negative_format: '( %n ) %u' )
    end
  end

  def negativo_rojo(monto)
    monto < 0 ? 'text-danger' : ''
  end

  # ver si la  obra esta persistida
  # version sin url 
  def hay_obra?
    @obra.try :persisted?
  end

  # decidir si vamos a incluir /obra/:obra_id en las urls o no, para
  # filtrar por obra
  def con_obra?(url)
    # los /obra/new tienen una obra que todavía no existe seteada
    if @obra.try :persisted?
      obra_path(@obra) + url
    else
      url
    end
  end

  def ruta_a_casa
    params[:obra_id] ? obra_path(params[:obra_id]) : root_path
  end

  # generar saltos entre obras desde la url actual
  # TODO cleverizar
  def con_esta_obra(obra = nil)
    # somos especificos con el controlador
    case params[:controller]
      when 'obras' then
        if obra
          # si la obra esta seteada, queremos verla
          url_for(params.merge({ action: 'show', id: obra.try(:id) }))
        else
          # sino, queremos ver el indice
          url_for(params.merge({ action: 'index', id: nil }))
        end
      when 'facturas' then
        case params[:action]
          # las facturas de cobros y pagos llevan al mismo listado en
          # otra obra
          when 'pagos' then url_for(params.merge({ obra_id: obra.try(:id) }))
          when 'cobros' then url_for(params.merge({ obra_id: obra.try(:id) }))
          # pero el resto lleva al listado de cobros o pagos segun que
          # factura estemos viendo
          else url_for(params.merge({ obra_id: obra.try(:id), action: @factura.try(:situacion) +'s', id: nil }))
        end
      when 'recibos' then
        case params[:action]
          # los recibos de cobros y pagos llevan al mismo listado en
          # otra obra
          when 'pagos' then url_for(params.merge({ obra_id: obra.try(:id), factura_id: nil }))
          when 'cobros' then url_for(params.merge({ obra_id: obra.try(:id), factura_id: nil }))
          # para las otras acciones vamos al listado segun la situacion
          # del recibo actual
          else
            if @recibo.interno?
              url_for(params.merge({ obra_id: obra.try(:id), controller: 'cajas', action: 'index', id: nil }))
            else
              url_for(params.merge({ obra_id: obra.try(:id), factura_id: nil, action: @recibo.try(:situacion) +'s', id: nil }))
            end
        end
      # para las cajas siempre queremos ir al indice de cajas segun obra
      when 'cajas' then url_for(params.merge({ obra_id: obra.try(:id), action: 'index', id: nil }))
      # para los cheques siempre queremos ir al indice de cheques segun
      # obra, que es el minimo comun denominador entre obras (las cajas
      # cambian!)
      when 'cheques' then url_for(params.merge({ obra_id: obra.try(:id), caja_id: nil, action: 'index', id: nil }))
      # las retenciones siempre llevan a su indice segun obra
      when 'retenciones' then url_for(params.merge({ obra_id: obra.try(:id), factura_id: nil, action: 'index', id: nil }))
      # los terceros no se filtran por obra
      when 'terceros' then url_for(params.merge({ obra_id: nil }))
      # los índices no se filtran por obra
      when 'indices' then url_for(params.merge({ obra_id: nil }))
      when 'unidades_funcionales' then url_for(params)
      when 'contratos_de_venta' then url_for(params)
      when 'cuotas' then url_for(params)
      # para cualquier otra cosa, imitar con_obra?
      else url_for(params.merge({ obra_id: obra.try(:id) }))
    end
  end

  def alert_range(num)
    if num == 0
      'info'
    elsif num > 0
      'success'
    elsif num < 0
      'danger'
    end
  end

  def sort_links(campo)
    html = link_to raw('<i class="glyphicon glyphicon-chevron-down"></i>'), url_for(params.merge({ sort: campo.to_s, order: 'asc' }))
    html += link_to raw('<i class="glyphicon glyphicon-chevron-up"></i>'), url_for(params.merge({ sort: campo.to_s, order: 'desc' }))
    html
  end

  def etiqueta_de_situacion(situacion)
    case situacion
      when 'pago' then 'label-primary'
      when 'cobro' then 'label-success'
      when 'propio' then 'label-primary'
      when 'terceros' then 'label-success'
      else 'label-default'
    end
  end

  def monedas
    ['ARS', 'USD']
  end

  # Convierte todos los mensajes de la lista en html bonito. Normalmente
  # `lista` es el flash, `tipo` es la llave (:notice, :error, etc)
  def mensajes(lista)
    lista.collect do |tipo, mensaje|
      content_tag :div, class: alerta(tipo) do
        content_tag(:button, '×', class: 'close', data: { dismiss: 'alert' }) +
        mensaje
      end
    end.join.html_safe
  end

  private

    def alerta(tipo)
      'alert alert-dismissable ' +
      case tipo.to_sym
        when :error
          'alert-danger'
        when :notice, :success
          'alert-success'
        when :alert
          'alert-warning'
        else
          tipo
      end
    end
end
