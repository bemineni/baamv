module SessionHelper

	def sign_in_setup(user)
		cookies.permanent[:remember_token] = user.remember_token
		current_user=user
	end

	def current_user=(user)
		@current_user=user 
	end

	def current_user 
		@current_user ||= set_current_user
	end 

	def current_user?(user)
		user == current_user
	end

	def is_signedin?
		current_user.nil?
	end

	def sign_out_user
		current_user=nil
		cookies.delete(:remember_token)
	end

	def signedin
		unless !is_signedin?
			store_location
			redirect_to login_path , :notice => "Please sign in"
		end
	end


	def redirect_back_or(default)
    	redirect_to(session[:return_to] || default)
    	clear_return_to
    end

	def store_location
		#This is like cookie which stores previous location
    	session[:return_to] = request.fullpath
    end

    def redirect_back_or(default)
    	redirect_to(session[:return_to] || default)
    	clear_return_to
    end

private

	def set_current_user
		remember_token = cookies[:remember_token]
		User.find_by_remember_token(remember_token) unless remember_token.nil?
    end

    def clear_return_to
      session.delete(:return_to)
  	end


end
