class AddObrasToFacturas < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up {
        obras = Obra.pluck(:id)

        Factura.reset_column_information
        Factura.find_each do |f|
          f.obra_id = obras.sample
          f.save
        end
      }
    end
  end
end
