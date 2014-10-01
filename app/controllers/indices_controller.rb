# encoding: utf-8
class IndicesController < ApplicationController
  before_action :set_indice, only: [:show, :edit, :update, :destroy]
  before_action :set_order, only: [ :index ]

  # GET /indices
  def index
    @indices = Indice.all.order(@order)
  end

  # GET /indice/1
  def show
    @editar = false
  end

  # GET /indices/new
  def new
    @indice = Indice.new
    @editar = true
  end

  # GET /indices/1/edit
  def edit
    @editar = true

    flash[:notice] = "Al modificar este índice se afectarán #{Indice.where(temporal: true).where('periodo > ?', @indice.periodo).count} índices temporales"
  end

  # POST /indices
  def create
    @indice = Indice.new(indice_params)

    respond_to do |format|
      if @indice.save
        format.html { redirect_to @indice, notice: 'Indice creado con éxito' }
        format.json { render action: 'show', status: :created, location: @indice }
      else
        format.html { render action: 'new' }
        format.json { render json: @indice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indices/1
  # PATCH/PUT /indices/1.json
  def update
    respond_to do |format|
      if @indice.update(indice_params)
        format.html { redirect_to @indice, notice: 'Indice actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @indice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1
  # DELETE /indices/1.json
  def destroy
    if @indice.destroy
      respond_to do |format|
        format.html { redirect_to indices_url }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_indice
      @indice = Indice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indice_params
      params.require(:indice).permit(:periodo, :denominacion, :valor, :temporal)
    end
end
