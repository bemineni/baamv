class UserChangeStateAndCountryId < ActiveRecord::Migration
  def up
  	rename_column :users, :state , :state_id
  	rename_column :users, :country , :country_id
  end

  def down
  end
end
