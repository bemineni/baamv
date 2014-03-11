class SessionController < ApplicationController

def new
  flash.now.notice = "Please log in to continue." if params[:return_path].present?
end

def create

	user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to params[:return_path] || root_url, :notice => "Logged in!"
    else
      user = User.find_by_email(params[:email])
      if user && user.activation_state == 'pending'
        flash.now.notice = "Account not yet activated, <a href='#{resend_activation_code_user_path(id: user.id)}'>resend activation code</a>.".html_safe
      else
        flash.now.alert = "Email or password was invalid."
      end
      render 'new'
    end

	# user = User.find_by_email(params[:session][:email])
	# if user and user.authenticate(params[:session][:password])

	# 	if user.verify_key != '0'
	# 		flash[:error] = "Account is not yet verified"
	# 		redirect_to root_path
	#     else
	# 		flash[:success] = "Successfully logged in"
	# 		sign_in_setup(user)
	# 		redirect_back_or root_path
	# 	end
		
	# else
	# 	flash[:error] = "Email address is not registered / Password is incorrect"
	# 	redirect_to login_path
	# end
	
end

def destroy
	logout
    redirect_to root_url, :notice => "Logged out!"
end


end
