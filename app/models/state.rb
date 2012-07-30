class State < ActiveRecord::Base
  attr_accessible :code, :name
  belongs_to :country
end
