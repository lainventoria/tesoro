# encoding: utf-8
class ContratosDeVentaController < ApplicationController
  before_action :set_obra
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]

  autocomplete :tercero, :nombre, :extra_data => [:cuit]
  autocomplete :tercero, :cuit, :extra_data => [:nombre]

  def index
    @contratos = @obra.contratos_de_venta
  end

  def show
    @editar = false
  end

  def new
    @editar = true
    @contrato = ContratoDeVenta.new
    @contrato.tercero = Tercero.new
  end

  def edit
    @editar = true
  end

  def create
    @contrato = ContratoDeVenta.new(contrato_de_venta_params)

    agregar_unidades
    agregar_cuotas

    respond_to do |format|
      if @contrato.save
        format.html { redirect_to [@contrato.obra, @contrato], notice: 'Contrato creado con éxito.' }
        format.json { render action: 'show', status: :created, location: @contrato }
      else
        format.html { render action: 'new' }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contrato.update(factura_params)
        format.html { redirect_to @contrato, notice: 'Contrato actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @contrato.destroy
      respond_to do |format|
        format.html { redirect_to obra_contratos_de_venta_path(@obra) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render action: :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_de_venta_params
      params.require(:contrato_de_venta).permit(
        :tercero_id, :obra_id,
        tercero_attributes: [ :nombre, :cuit ]
      )
    end

    def agregar_unidades
      params[:unidades_funcionales].each do |uf| 
        unidad = UnidadFuncional.find(uf.first)
        p = uf[1]['precio_venta'].sub(',','').sub('.','').to_i
        unidad.precio_venta_final_centavos = p
        unidad.precio_venta_final_moneda = unidad.precio_venta_moneda
        @contrato.agregar_unidad_funcional(unidad)
      end
    end

    def agregar_cuotas
      f = params['fechas']
      m = params['montos']
      i = 1
      f.zip(m).sort.map { |fecha,monto| @contrato.agregar_cuota(vencimiento: fecha, monto_original: monto, descripcion: "Cuota ##{i}") }
    end

end
