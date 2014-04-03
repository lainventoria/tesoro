class AddSituacionToRetenciones < ActiveRecord::Migration
  def change
    add_column :retenciones, :situacion, :string, default: 'ganancias'
  end
end
