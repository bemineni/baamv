class UserChangeStateAndCountryId < ActiveRecord::Migration
  def up
  	rename_column :users, :state , :state_id
  	rename_column :users, :country , :country_id
  end

  def down
  	rename_column :users, :state_id , :state
  	rename_column :users, :country_id , :country
  end
end
