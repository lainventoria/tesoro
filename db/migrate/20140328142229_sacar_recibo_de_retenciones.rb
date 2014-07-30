class SacarReciboDeRetenciones < ActiveRecord::Migration
  def up
    remove_column :retenciones, :recibo_id
  end

  def down
    add_column :retenciones, :recibo_id, :integer
    add_index "retenciones", ["recibo_id"], name: "index_retenciones_on_recibo_id"
  end
end
