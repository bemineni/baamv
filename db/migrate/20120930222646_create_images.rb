class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :file
      t.references :imageattachable, :polymorphic => true

      t.timestamps
    end
    add_index :images, :imageattachable_id
  end
end
