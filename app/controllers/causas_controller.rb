# encoding: utf-8
class CausasController < ApplicationController
  before_action :set_factura

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
end
