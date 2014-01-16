class CreateThirdParties < ActiveRecord::Migration
  def change
    create_table :third_parties do |t|
      t.string :name
      t.text :address
      t.text :phone
      t.text :cellphone
      t.string :email
      t.float :tax

      t.timestamps
    end
  end
end
