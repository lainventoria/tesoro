class CajaQuitarTipoDefault < ActiveRecord::Migration

  # TODO ver como evitar perder los tipos existentes al borrar la
  # antigua columna tipo y traspasarlos a la nueva columna tipo

  def up
    remove_column :cajas, :tipo
    add_column :cajas, :tipo, :string
  end

  def down
    add_column :cajas, :tipo, :string, null: false, default: 'De obra'
    remove_column :cajas, :tipo
  end
end
