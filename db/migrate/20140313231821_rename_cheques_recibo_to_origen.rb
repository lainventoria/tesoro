class RenameChequesReciboToOrigen < ActiveRecord::Migration
  def change
    remove_index :cheques, :recibo_id
    rename_column :cheques, :recibo_id, :origen_id
    add_index :cheques, :origen_id
  end
end
