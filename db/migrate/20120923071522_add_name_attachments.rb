class AddNameAttachments < ActiveRecord::Migration
  def up
  	add_column :attachments, :name , :string
  	add_index :attachments, :name
  end

  def down
  	remove_column :attachments , :name
  end
end
