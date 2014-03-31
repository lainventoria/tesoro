# encoding: utf-8
class ChequesController < ApplicationController
  before_action :set_obra
  before_action :set_caja, only: [ :index, :propios, :terceros ]
  before_action :set_cheque, only: [ :show, :edit, :update, :destroy ]

  def index
    @cheques = @caja ? @caja.cheques : Cheque.all
  end

  def show
    @editar = false
  end

  # TODO borrar cuando ya exista interfase para crear cheques
  def new
    @cheque = Cheque.new
    @editar = true
  end

  def propios
    @cheques = (@caja ? @caja.cheques : Cheque).propios
    @situacion = "propios"
    render "index"
  end

  def terceros
    @cheques = (@caja ? @caja.cheques : Cheque).de_terceros
    @situacion = "terceros"
    render "index"
  end

  private

    def set_cheque
      @cheque = (@obra.present? ? @obra.cheques : Cheque).find(params[:id])
    end

    def cheque_params
      params.require(:cheque).permit(
        :situacion, :numero, :monto_centavos, :monto_moneda,
        :fecha_vencimiento, :fecha_emision, :beneficiario, :banco, :estado
      )
    end

    def set_caja
      @caja = params[:caja_id].present? ? Caja.find(params[:caja_id]) : nil
    end
end
