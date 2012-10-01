class Image < ActiveRecord::Base
   belongs_to :imageattachable ,:polymorphic => true 
   attr_accessible :name, :file

   mount_uploader :file , ImageUploader
end
