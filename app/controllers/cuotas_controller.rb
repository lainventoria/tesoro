# encoding: utf-8
class CuotasController < ApplicationController
  before_action :set_obra
  before_action :set_order, only: [:index]

  def index
    @cuotas = @obra.cuotas

    if params[:date].present?
      if params[:date][:year].present?
        # FIXME year() es específico de mysql, pg usa extract(year from
        # :vencimiento)
        @cuotas = @cuotas.where('year(vencimiento) = ?', params[:date][:year])
      end

      if params[:date][:month].present?
        # FIXME idem anterior
        @cuotas = @cuotas.where('month(vencimiento) = ?', params[:date][:month].to_i)
      end
    else
      @cuotas = @cuotas.where(vencimiento: Date.today.beginning_of_month)
    end

    @cuotas = @cuotas.order(@order)
  end

  def show
    @editar = false
    @cuota = @obra.cuotas.find(params[:id])
  end
end
