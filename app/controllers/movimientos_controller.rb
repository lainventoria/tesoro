# encoding: utf-8
# Este controlador sólo renderiza el partial adecuado para la carga de
# movimientos
class MovimientosController < ApplicationController
  before_action :set_factura

  def new
    respond_to do |format|
      if modelo_de_causa.present?
        format.js { render partial: partial_segun_causa, layout: false }
      else
        render status: 404
      end
    end
  end

  private

    def partial_segun_causa
      # Volvemos a usar :causa_tipo acá porque tanto para cheque-propio como
      # cheque-de-terceros el modelo es Cheque, y necesitamos partials
      # diferentes
      params[:causa_tipo].underscore
    end
end
