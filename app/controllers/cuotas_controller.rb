# encoding: utf-8
class CuotasController < ApplicationController
  before_action :set_obra

  def index
    @cuotas = @obra.cuotas
  end

  def show
    @editar = false
    @cuota = (@obra.present? ? @obra.cuotas : Cuota).find(params[:id])
  end
end
