class User < ActiveRecord::Base
   attr_accessible :firstname,:lastname,:initial,:sex,:address,:city,:state_id,:country_id ,
                   :zip,:email,:phone,:mobile,:password,:password_confirmation,:verify_key ,
                   :remember_token
   belongs_to :country
   belongs_to :state 

   has_secure_password

   before_save { |user| user.email = email.downcase }
   before_save :create_verify_key
   before_save :create_remember_token

   validates :firstname, :presence => true, :length => { :maximum => 20 }
   validates :lastname, :presence => true, :length => { :maximum => 20 }
   SEX_REGEX = /^(male|female)$/i
   validates :sex, :presence => true, :length => { :maximum => 6 }, :format => { :with => SEX_REGEX }
   validates :city, :presence => true
   validates :state_id, :presence => true
   validates :country_id, :presence => true
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email,:presence  => true ,:format => {:with => VALID_EMAIL_REGEX },:uniqueness => { :case_sensitive => false} 
   validates :password, :presence => true,:length => {:minimum => 6 } , :on => :create
   validates :password_confirmation, :presence => true, :on => :create
   
private

   def create_verify_key
      if self.verify_key != "0"
         self.verify_key = Digest::MD5.hexdigest("#{self.email}#{self.firstname}#{self.lastname}")
      end
   end

   def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
   end
   
end
