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

      Accountverification.verify(@user).deliver

		  redirect_to @user
  	else
  		render 'new'
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

  def verify
    if (@user = User.load_from_activation_token(params[:token]))
      @user.activate!
    else
      not_authenticated
    end

    # @user = User.find_by_verify_key(params[:key])
    # @verified = false 
    # if !@user.nil?
    #   @user.update_attributes!( :verify_key => "0" )
    #   @verified = true;
    # end
  end



end
