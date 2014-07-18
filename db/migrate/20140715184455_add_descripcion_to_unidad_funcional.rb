class AddDescripcionToUnidadFuncional < ActiveRecord::Migration
  def change
    add_column :unidades_funcionales, :descripcion, :text, null: true
  end
end
