class CajaQuitarTipoDefault < ActiveRecord::Migration
  def up
    remove_column :cajas, :tipo
    add_column :cajas, :tipo, :string
  end

  def down
    add_column :cajas, :tipo, :string, null: false, default: 'De obra'
    remove_column :cajas, :tipo
  end
end
