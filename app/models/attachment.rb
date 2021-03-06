class Attachment < ActiveRecord::Base
  belongs_to :attachable ,:polymorphic => true 
  attr_accessible :description, :name , :file

  mount_uploader :file , FileUploader
end
