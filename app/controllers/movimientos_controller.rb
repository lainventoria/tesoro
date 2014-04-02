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
      modelo_de_causa.name.underscore
    end
end
