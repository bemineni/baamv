class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|

    	t.string :title
    	t.text :body
    	t.integer :author
    	t.integer :views
    	t.boolean :published 
      	t.timestamps
    end
  end
end
