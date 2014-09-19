class CambiarCajaPorCuentaEnCheques < ActiveRecord::Migration
  def change
    remove_index :cheques, :caja_id
    rename_column :cheques, :caja_id, :cuenta_id
    add_index :cheques, :cuenta_id
  end
end
