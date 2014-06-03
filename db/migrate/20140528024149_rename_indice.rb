class RenameIndice < ActiveRecord::Migration
  def change
    rename_column :indices, :indice, :valor
  end
end
