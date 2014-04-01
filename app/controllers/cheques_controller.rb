# encoding: utf-8
class ChequesController < ApplicationController
  before_action :set_obra_y_caja
  before_action :set_cheque, only: [ :show, :edit, :update, :destroy ]

  def index
    if params[:situacion]
      @cheques = (@caja ? @caja.cheques : Cheque).where(situacion: params[:situacion])
    else
      @cheques = @caja ? @caja.cheques : Cheque.all
    end

    if params[:vencidos]
      @cheques = @cheques.vencidos
    end

  end

  def show
    @editar = false
  end

  # TODO borrar 'new' cuando exista interfase para crear cheques
  def new
    @cheque = Cheque.new
    @editar = true
  end

  def edit
    @editar = true
  end

  def create
    @cheque = Cheque.new(cheque_params)

    respond_to do |format|
      if @cheque.save
        format.html { redirect_to [@cheque.chequera.obra, @cheque.chequera, @cheque], notice: 'Cheque creado con éxito.' }
        format.json { render action: 'show', status: :created, location: [@cheque.chequera.obra, @cheque.chequera, @cheque] }
      else
        format.html { render action: 'new' }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cheque.update(cheque_params)
        format.html { redirect_to [@cheque.chequera.obra, @cheque.chequera, @cheque], notice: 'Cheque actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    volver_a_listado = obra_cajas_url @cheque.chequera.obra, @cheque.chequera
    @cheque.destroy
    respond_to do |format|
      format.html { redirect_to volver_a_listado }
      format.json { head :no_content }
    end
  end

  private

    def set_cheque
      @cheque = (@obra.present? ? @obra.cheques : Cheque).find(params[:id])
    end

    def cheque_params
      params.require(:cheque).permit(
        :situacion, :numero, :monto, :monto_centavos, :monto_moneda,
        :fecha_vencimiento, :fecha_emision, :beneficiario, :banco, :estado,
        :chequera_id, :cuenta_id, :obra_id
      )
    end

    def set_obra_y_caja
      if params[:caja_id]
        @caja = Caja.find(params[:caja_id])
        @obra = @caja.obra
      end
    end
end
