class User < ActiveRecord::Base
   attr_accessible :username,:firstname,:lastname,:initial,:sex,:address,:city,:state,:country,:zip,:email,:phone,:mobile,:password,:password_confirmation

   has_secure_password

   before_save { |user| user.email = email.downcase }

   validates :username, :presence => true, :length => { :maximum => 10 }
   validates :firstname, :presence => true, :length => { :maximum => 20 }
   validates :lastname, :presence => true, :length => { :maximum => 20 }
   validates :initial, :presence => true, :length => { :maximum => 4 }
   SEX_REGEX = /^(male|female)$/i
   validates :sex, :presence => true, :length => { :maximum => 6 }, :format => { :with => SEX_REGEX }
   validates :city, :presence => true
   validates :state, :presence => true
   validates :country, :presence => true
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email,:presence  => true ,:format => {:with => VALID_EMAIL_REGEX },:uniqueness => { :case_sensitive => false} 
   validates :phone, :presence => true
   validates :password, :presence => true,:length => {:minimum => 6 } 
   validates :password_confirmation, :presence => true
   
end
