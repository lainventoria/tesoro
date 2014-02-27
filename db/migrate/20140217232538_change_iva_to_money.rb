class ChangeIvaToMoney < ActiveRecord::Migration
  def up
    remove_column :facturas, :iva
    add_money :facturas, :iva
  end

  def down
    remove_money :facturas, :iva
    add_column :facturas, :iva, :float
  end
end
