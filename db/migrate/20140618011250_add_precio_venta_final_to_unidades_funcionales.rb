class AddPrecioVentaFinalToUnidadesFuncionales < ActiveRecord::Migration
  def change
    add_money :unidades_funcionales, :precio_venta_final
  end
end
