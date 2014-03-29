class RetencionAgregaFecha < ActiveRecord::Migration
  def up
    add_column :retenciones, :fecha_vencimiento, :date
  end

  def down
    remove_column :retenciones, :fecha_vencimiento
  end
end
