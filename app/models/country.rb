class Country < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :states, :dependent => :destroy
end
