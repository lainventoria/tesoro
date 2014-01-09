class CreateObras < ActiveRecord::Migration
  def change
    create_table :obras do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
