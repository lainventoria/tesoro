class AddUnidadFuncional < ActiveRecord::Migration
  def change
    create_table :unidades_funcionales do |t|
      t.integer  :obra_id,       null:  false
      t.money    :precio_venta,  null:  false
      t.string   :tipo,          null:  false
    end
  end
end
