class AddIndexes < ActiveRecord::Migration
  def change
    add_index :cuotas, :contrato_de_venta_id
    add_index :contratos_de_venta, :tercero_id
    add_index :contratos_de_venta, :indice_id
  end
end
