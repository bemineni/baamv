class AddVerifyColumnToUsers < ActiveRecord::Migration
  def up
  	add_column :users , :verify_key , :string
  end

  def down
  	remove_column :users, :verify_key
  end
end
