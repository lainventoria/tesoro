class AddEstadoToRetenciones < ActiveRecord::Migration
  def change
    add_column :retenciones, :estado, :string, null: false, default: 'emitida'
  end
end
