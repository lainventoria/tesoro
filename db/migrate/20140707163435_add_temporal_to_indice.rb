class AddTemporalToIndice < ActiveRecord::Migration
  def change
    add_column :indices, :temporal, :boolean, default: false
  end
end
