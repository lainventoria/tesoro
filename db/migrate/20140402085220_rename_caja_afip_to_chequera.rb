class RenameCajaAfipToChequera < ActiveRecord::Migration
  def change
    remove_index :retenciones, :caja_afip_id
    rename_column :retenciones, :caja_afip_id, :chequera_id
    add_index :retenciones, :chequera_id
  end
end
