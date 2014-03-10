class AddOtherUserFields < ActiveRecord::Migration
  def change
  	  add_column :users, :username , :string ,  :default => nil
      add_column :users, :firstname, :string ,  :default => nil
      add_column :users, :lastname , :string ,  :default => nil
      add_column :users, :sex , :string ,  :default => nil
      add_column :users, :address, :text , :default => nil
      add_column :users, :city,  :string , :default => nil
      add_column :users, :state_id, :integer,:default => nil
      add_column :users, :country_id , :integer , :defualt => nil
      add_column :users, :zip , :string ,:default => nil
      add_column :users, :phone, :string , :default => nil
      add_column :users, :mobile, :string , :default => nil
  end
end
