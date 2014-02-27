class AddNetoAFactura < ActiveRecord::Migration
  def change
    add_money :facturas, :importe_neto
  end
end
