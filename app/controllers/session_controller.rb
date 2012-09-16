class SessionController < ApplicationController

def new

end

def create
	user = User.find_by_email(params[:session][:email])
	if user and user.authenticate(params[:session][:password])

		if user.verify_key != '0'
			flash[:error] = "Account is not yet verified"
			redirect_to root_path
	    else
			flash[:success] = "Successfully logged in"
			sign_in_setup(user)
			redirect_back_or root_path
		end
		
	else
		flash[:error] = "Email address is not registered / Password is incorrect"
		redirect_to login_path
	end
	
end

def destroy
	sign_out_user
    redirect_to root_path
end


end
