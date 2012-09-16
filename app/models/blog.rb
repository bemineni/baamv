class Blog < ActiveRecord::Base
  attr_accessible :title, :body, :author, :views
  belongs_to :user , :foreign_key => :author

  validates :author, presence: true
  validates :title, presence: true
  validates :body, presence: true

end
