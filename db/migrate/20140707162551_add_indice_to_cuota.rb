class AddIndiceToCuota < ActiveRecord::Migration
  def change
    add_reference :cuotas, :indice, index: true
  end
end
