class Blog < ActiveRecord::Base
  attr_accessible :title, :body, :author, :views,:published,:attachments_attributes
  belongs_to :user , :foreign_key => :author
  has_many :attachments, :as => :attachable , :dependent => :destroy

  # with this you can even edit the attachment model
  # which is associated with the Blog model.
  accepts_nested_attributes_for :attachments , :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true

  validates :author, presence: true
  validates :title, presence: true
  validates :body, presence: true

  def self.not_saved_blogs
  	where("created_at=updated_at").all
  end	

  def self.published_blogs
  	where("published=true").all
  end

end
