class AddImporteCacheToRecibos < ActiveRecord::Migration
  def up
    add_money :recibos, :importe_cache 
  end

  def down
    remove_money :recibos, :importe_cache
  end
end
