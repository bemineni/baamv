class Addcountryid < ActiveRecord::Migration
  def up
  	add_column :states, :country_id, :integer
  	add_index :states , [:country_id]
  end

  def down
  end
end
