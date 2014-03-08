class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.text :description
      t.string :file
      t.references :attachable, :polymorphic => true

      t.timestamps
    end
    add_index :attachments, :name
    add_index :attachments, :attachable_id
  end
end
