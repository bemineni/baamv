class UserChangeStateAndCountryType < ActiveRecord::Migration
  def up
  	change_column :users , :country,  :integer
  	change_column :users , :state,  :integer
  	drop_table  :cities
  end

  def down
  	change_column :users , :country,  :string
  	change_column :users , :state,  :string
  	create_table :cities do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
