class AddIndice < ActiveRecord::Migration
  def change
    create_table :indices do |t|
      t.timestamps

      t.date      :periodo
      t.string    :denominacion
      t.decimal   :indice
    end
  end
end
