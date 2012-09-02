class Blog < ActiveRecord::Base
  attr_accessible :title, :body, :author, :views
end
