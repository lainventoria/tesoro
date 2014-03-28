# encoding: utf-8
class CausasController < ApplicationController
  before_action :set_factura_y_obra

  def new
    @causa = if params[:causa_tipo] == 'retencion'
      @factura.retencion
    else
      causa.try :new
    end

    respond_to do |format|
      if @causa.present?
        format.js { render partial: "causas/#{causa_conocida}", layout: false }
      else
        render status: 404
      end
    end
  end

  private

    def set_factura_y_obra
      if params[:factura_id]
        @factura = Factura.find(params[:factura_id])
        @obra = @factura.obra
      end
    end
end
