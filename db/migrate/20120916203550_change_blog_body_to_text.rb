class ChangeBlogBodyToText < ActiveRecord::Migration
  def up
  	change_column :blogs , :body , :text
  end

  def down
  	change_column :blogs , :body , :string
  end
end
