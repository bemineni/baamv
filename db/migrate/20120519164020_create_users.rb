class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :username
      t.string :firstname
      t.string :lastname
      t.string :initial
      t.string :sex
      t.text   :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.string :email
      t.string :phone
      t.string :mobile

      t.timestamps
    end
  end
end
