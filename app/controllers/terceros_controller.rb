# encoding: utf-8
class TercerosController < ApplicationController
  before_action :set_tercero, only: [:show, :edit, :update, :destroy]
  before_action :set_order, only: [:index]

  autocomplete :tercero, :nombre, extra_data: [:cuit]
  autocomplete :tercero, :cuit, extra_data: [:nombre]

  def index
    @terceros = Tercero.all.order(@order)
  end

  def show
    @editar=false
  end

  def new
    @tercero = Tercero.new
    @editar = true
  end

  def edit
    @editar=true
  end

  def create
    @tercero = Tercero.new(tercero_params)

    respond_to do |format|
      if @tercero.save
        format.html { redirect_to @tercero, notice: 'Tercero creado con éxito' }
        format.json { render action: 'show', status: :created, location: @tercero }
      else
        format.html { render action: 'new' }
        format.json { render json: @tercero.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tercero.update(tercero_params)
        format.html { redirect_to @tercero, notice: 'Tercero actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tercero.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @tercero.destroy
      respond_to do |format|
        format.html { redirect_to terceros_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_tercero
      @tercero = Tercero.find(params[:id])
    end

    def tercero_params
      params.require(:tercero).permit(
        :nombre, :direccion, :telefono, :celular, :email, :iva, :relacion,
        :cuit, :contacto, :notas
      )
    end
end
