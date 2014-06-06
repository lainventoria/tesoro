class AddCuota < ActiveRecord::Migration
  def change
    create_table :cuotas do |t|
      t.timestamps

      t.money  :monto_original
      t.date   :vencimiento
      t.string :descripcion

      # TODO: migración para agregar UnidadFuncional

    end
  end
end
