class CreateCheque < ActiveRecord::Migration
  def change
    create_table :cheques do |t|
      t.belongs_to :cuenta, index: true

      t.string :situacion, default: 'propio'
      t.integer :numero
      t.money :monto
      t.timestamp :fecha_vencimiento
      t.timestamp :fecha

      t.timestamps
    end
  end
end
