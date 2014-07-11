class CuotasNotNull < ActiveRecord::Migration
  def up
    change_column :cuotas, :vencimiento, :date, null: false
    change_column :cuotas, :descripcion, :string, null: false
  end

  def down
    change_column :cuotas, :vencimiento, :date, null: true
    change_column :cuotas, :descripcion, :string, null: true
  end
end
