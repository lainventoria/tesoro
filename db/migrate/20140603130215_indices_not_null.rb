class IndicesNotNull < ActiveRecord::Migration
  def up
    change_column :indices, :periodo, :date, null: false
    change_column :indices, :denominacion, :string, null: false
    change_column :indices, :valor, :decimal, null: false
  end

  def down
    change_column :indices, :periodo, :date, null: true
    change_column :indices, :denominacion, :string, null: true
    change_column :indices, :valor, :decimal, null: true
  end
end
