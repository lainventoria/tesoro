class RemoveIndiceContratosDeVenta < ActiveRecord::Migration
  def up
    remove_column :contratos_de_venta, :indice_base
  end

  def down
    add_column :contratos_de_venta, :indice_base, :decimal
  end
end
