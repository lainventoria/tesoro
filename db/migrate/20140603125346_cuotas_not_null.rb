class CuotasNotNull < ActiveRecord::Migration
  def change
    change_column :cuotas, :vencimiento, :date, null: false
    change_column :cuotas, :descripcion, :string, null: false
  end
end
