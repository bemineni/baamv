class Removecountrycode < ActiveRecord::Migration
  def up
  	remove_column :states, :countrycode
  end

  def down
  	add_column :states, :countrycode, :string
  end
end
