class AddContratosDeVenta < ActiveRecord::Migration
  def change
    create_table :contratos_de_venta do |t|
      t.money    :monto_total,  null: false
      t.decimal  :indice_base,  null: false
      t.date     :fecha,        null: false
      t.integer  :indice_id,    null: false
      t.integer  :tercero_id,   null: false

      t.timestamps
    end

    add_column :cuotas, :contrato_de_venta_id, :integer
  end
end
