class User < ActiveRecord::Base
  authenticates_with_sorcery!
  belongs_to :city
  belongs_to :state
  has_many :blogs , :foreign_key => :author, :dependent => :destroy

  attr_accessible :username, :firstname,:lastname,:initial,:sex,:address,:city,:state_id,
                  :country_id ,:zip,:email,:email_confirmation,:phone,:mobile,:password,:password_confirmation

   before_save { |user| user.email = email.downcase }

   USERNAME_REGEX = /^[a-zA-Z0-9]+$/i
   validates :username, :presence => true, :length => { :maximum => 15 } , :format => { :with => USERNAME_REGEX }
   validates :firstname, :presence => true, :length => { :maximum => 20 }
   validates :lastname, :presence => true, :length => { :maximum => 20 }
   validates_presence_of :password, on: :create
   validates_presence_of :password_confirmation, :on => :create
   validates_confirmation_of :password, on: :create , message: 'should match password'
   validates_presence_of :email
   validates_presence_of :email_confirmation , :on => :create
   validates_confirmation_of :email, on: :create, message: 'should match email'
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email,:presence  => true ,:format => {:with => VALID_EMAIL_REGEX },:uniqueness => { :case_sensitive => false} 

   SEX_REGEX = /^(male|female)$/i
   validates :sex, :presence => true, :length => { :maximum => 6 }, :format => { :with => SEX_REGEX }
   validates :city, :presence => true
   validates :state_id, :presence => true
   validates :country_id, :presence => true

   def name=(name)
    self.first_name, self.last_name = name.split(" ", 2)
   end

   def name
    "#{self.first_name} #{self.last_name}"
   end
  
end
