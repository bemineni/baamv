class Addcountryid < ActiveRecord::Migration
  def up
  	add_column :states, :country_id, :integer
  	add_index :states , [:country_id]
  end

  def down
  	remove_index :states , [:country_id]
  	remove_column :states, :country_id
  end
end
