class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    # Hay que declararlo antes que cualquier otro before_action en los
    # controladores que lo necesiten
    def set_obra
      @obra = params[:obra_id].present? ? Obra.find(params[:obra_id]) : nil
    end

    # Este va inmediatamente después de set_obra, si se usa
    def set_factura
      if params[id_para_factura]
        @factura = (@obra.present? ? @obra.facturas : Factura).find(params[id_para_factura])
      end
    end

    # set_factura lo usa para determinar cómo cargar la factura
    def id_para_factura
      params[:controller] == 'facturas' ? :id : :factura_id
    end

    def causa_conocida
      if %w{
        cheque-propio cheque-de-terceros efectivo transferencia retencion
      }.include? params[:causa_tipo]
        params[:causa_tipo].underscore
      else
        nil
      end
    end

    def causa
      causa_conocida.classify.constantize if causa_conocida.present?
    end

    def causa_params
      if params[:causa].present?
        params[:causa].permit(:monto, :caja_id)
      else
        {}
      end
    end
end
