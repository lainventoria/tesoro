class AddFacturaToCuota < ActiveRecord::Migration
  def change
    add_reference :cuotas, :factura, index: true
  end
end
