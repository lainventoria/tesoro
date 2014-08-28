class AddTipoFacturaToContratoDeVenta < ActiveRecord::Migration
  def change
    add_column :contratos_de_venta, :tipo_factura, :string
  end
end
