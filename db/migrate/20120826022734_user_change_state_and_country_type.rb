class UserChangeStateAndCountryType < ActiveRecord::Migration
  def up
  	change_column :users , :country,  :integer
  	change_column :users , :state,  :integer
  	remove_column :states , :countrycode
  	drop_table  :cities

  end

  def down
  end
end
