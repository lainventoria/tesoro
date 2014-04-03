class DropImporteFromRecibos < ActiveRecord::Migration
  def up
    remove_money :recibos, :importe
  end

  def down
    add_money :recibos, :importe
  end
end
