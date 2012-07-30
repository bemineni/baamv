class Removecountrycode < ActiveRecord::Migration
  def up
  end

  def down
   remove_column :states, :countrycode
  end
end
