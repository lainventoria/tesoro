# encoding: utf-8
# Este controlador sólo renderiza el partial adecuado para la carga de
# movimientos
class MovimientosController < ApplicationController
  before_action :set_factura

  def new
    # FIXME varias retenciones
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
end
