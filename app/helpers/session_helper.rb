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

	def is_signedin?
		current_user.nil?
	end

	def sign_out_user
		current_user=nil
		cookies.delete(:remember_token)
	end

private

	def set_current_user
		remember_token = cookies[:remember_token]
		User.find_by_remember_token(remember_token) unless remember_token.nil?
    end
end
