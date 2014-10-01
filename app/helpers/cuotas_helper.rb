module CuotasHelper
  # para usar en select_month y select_year
  def date_from_params
    if params[:date].present?
      # toda esta verga porque month es "" en lugar de nil cuando mandás
      # un valor vacío
      month = if params[:date][:month].empty?
        1
      else
        params[:date][:month]
      end

      Date.strptime("#{params[:date][:year]}, #{month}, 1", '%Y, %m, %d')
    else
      Date.today
    end
  end

  # devuelve un tipo de etiqueta según el estado de la cuota
  def etiqueta_de_cuota(cuota)
    case cuota.estado
      when 'vencida' then 'label-warning'
      when 'facturada' then 'label-info'
      when 'cobrada' then 'label-success'
      else ''
    end
  end
end
