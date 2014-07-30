class CajaQuitarTipoDefault < ActiveRecord::Migration

  # TODO ver como evitar perder los tipos existentes al borrar la
  # antigua columna tipo y traspasarlos a la nueva columna tipo
  def up
    change_column_default :cajas, :tipo, nil
  end

  def down
    change_column_default :cajas, :tipo, 'De obra'
  end
end
