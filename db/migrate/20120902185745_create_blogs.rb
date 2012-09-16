class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|

    	t.string :title
    	t.string :body
    	t.integer :author
    	t.integer :views
      	t.timestamps
    end
  end
end
