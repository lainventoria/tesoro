class ChangeClienteFromTerceros < ActiveRecord::Migration
  def up
    change_column :terceros, :cliente, :boolean
  end

  def down
    change_column :terceros, :cliente, :binary
  end
end
