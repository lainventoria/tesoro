class RemoveIndiceContratosDeVenta < ActiveRecord::Migration
  def change
    remove_column :contratos_de_venta, :indice_base
  end
end
