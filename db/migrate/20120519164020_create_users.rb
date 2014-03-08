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
      t.integer :state_id
      t.integer :country_id
      t.string :zip
      t.string :email
      t.string :phone
      t.string :mobile
      t.string :verify_key
      t.string :remember_token
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :username, :unique => true 
    add_index :users, :email , :unique => true
  end
end
