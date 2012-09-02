class UsersController < ApplicationController
   
  
  def show
  	@user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    
  	@user = User.new(params[:user])
  	if @user.save
		  #This is a successful case
		  flash[:success] = "Thank you for registering with #{APPNAME}. \
                         Please check your email #{@user.email} to verify the newly created account"

      Accountverification.verify(@user).deliver

		  redirect_to @user
  	else
  		render 'new'
  	end

  end

  def verify
    @user = User.find_by_verify_key(params[:key])
    @verified = false 
    if !@user.nil?
      @user.update_attributes!( :verify_key => "0" )
      @verified = true;
    end
  end



end
