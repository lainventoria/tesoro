class IndiceParaIndices < ActiveRecord::Migration
  def change
    add_index :indices, [:periodo, :denominacion], unique: true
  end
end
