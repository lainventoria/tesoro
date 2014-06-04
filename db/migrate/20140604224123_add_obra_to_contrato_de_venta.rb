class AddObraToContratoDeVenta < ActiveRecord::Migration
  def change
    add_column :contratos_de_venta, :obra_id, :integer
    add_index :contratos_de_venta, :obra_id
  end
end
