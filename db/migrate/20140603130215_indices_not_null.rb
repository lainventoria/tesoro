class IndicesNotNull < ActiveRecord::Migration
  def change
    change_column :indices, :periodo, :date, null: false
    change_column :indices, :denominacion, :string, null: false
    change_column :indices, :valor, :decimal, null: false
  end
end
