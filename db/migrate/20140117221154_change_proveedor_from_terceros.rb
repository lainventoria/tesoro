class ChangeProveedorFromTerceros < ActiveRecord::Migration
  def up
    change_column :terceros, :proveedor, :boolean
  end

  # fauno puso binary :P
  def down
    change_column :terceros, :proveedor, :binary
  end
end
