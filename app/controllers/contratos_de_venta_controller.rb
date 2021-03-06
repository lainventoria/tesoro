# encoding: utf-8
class ContratosDeVentaController < ApplicationController
  before_action :set_obra
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]

  def index
    @contratos = @obra.contratos_de_venta
  end

  def show
    @editar = false
  end

  def new
    @editar = true
    @contrato = ContratoDeVenta.new
    @contrato.build_tercero
  end

  def edit
    @editar = true
  end

  def create
    @contrato = ContratoDeVenta.new(contrato_de_venta_params)

    @contrato.indice = @contrato.indice_para(@contrato.fecha)
    agregar_unidades
    agregar_cuotas

    respond_to do |format|
      if @contrato.save
        format.html do
          redirect_to [@contrato.obra, @contrato],
            notice: 'Contrato creado con éxito.'
        end
        format.json { render action: 'show', status: :created, location: @contrato }
      else
        format.html { render action: 'new' }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contrato.update(contrato_de_venta_params)
        format.html do
          redirect_to [@contrato.obra, @contrato],
            notice: 'Contrato actualizado con éxito.'
        end
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
        :tercero_id, :obra_id, :relacion_indice, :tipo_factura, :fecha,
        tercero_attributes: [
          :nombre, :cuit
        ]
      )
    end

    # TODO refactorizar
    def agregar_unidades
      params[:unidades_funcionales].each do |uf|
        unidad = UnidadFuncional.find(uf.first)
        unidad.precio_venta_final_centavos = uf[1]['precio_venta'].gsub(/[,\.]/, '').to_i
        unidad.precio_venta_final_moneda = uf[1]['precio_venta_moneda']
        @contrato.agregar_unidad_funcional(unidad)
      end
    end

    # TODO refactorizar
    def agregar_cuotas
      moneda = @contrato.unidades_funcionales.first.precio_venta_final_moneda

      f = params[:fechas]
      m = params[:montos]
      i = 1
      cuotas = f.zip(m).sort_by { |c| c[0].to_time }
      primer = cuotas.shift

      @contrato.agregar_pago_inicial(primer[0], Money.new(primer[1].gsub(/[,\.]/,'').to_i, moneda))

      cuotas.map do |fecha, monto|
        @contrato.agregar_cuota vencimiento: fecha, monto_original: Money.new(monto.gsub(/[,\.]/, '').to_i, moneda),
          descripcion: "Cuota ##{i}"

        i+=1
      end
    end

    def set_contrato
      @contrato = ContratoDeVenta.find(params[:id])
    end
end
