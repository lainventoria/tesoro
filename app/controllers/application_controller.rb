class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    def set_obra
      @obra = params[:obra_id].present? ? Obra.find(params[:obra_id]) : nil
    end

    def causa_conocida
      if %w{
        cheque-propio cheque-de-terceros efectivo transferencia retencion
      }.include? causa_params[:tipo]
        causa_params[:tipo].underscore
      else
        nil
      end
    end

    def causa
      causa_conocida.classify.constantize if causa_conocida.present?
    end

    def causa_params
      params.require(:causa)
    end
end
