class RenameCajaAfipToChequera < ActiveRecord::Migration
  def change
    rename_column :retenciones, :caja_afip_id, :chequera_id
  end
end
