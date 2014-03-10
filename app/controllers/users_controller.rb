class UsersController < ApplicationController
   
  
  def show
  	@user = current_user
  end

  def new
    @user = User.new
  end

  def create
    
  	@user = User.new(params[:user])

  	if @user.save
		  #This is a successful case
		  flash[:success] = "Thank you for registering with #{Baamv::Application.config.appname}. \
                         Please check your email #{@user.email} to verify the newly created account"

		  redirect_to root_path
  	else
  		render :new
  	end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path, notice: "Profile updated."
    else
      render :edit
    end
  end


  def activate
    if (@user = User.load_from_activation_token(params[:token]))
      @user.activate!
    else
      not_authenticated
    end
  end



end
