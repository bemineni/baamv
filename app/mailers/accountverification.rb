class Accountverification < ActionMailer::Base
  default from: "srikanth.bemineni@gmail.com"

  def activation_needed_email(user)
    @user = user
    @url  = "#{host}user/activate?token=#{user.activation_token}"
    mail(:to => user.email,
         :subject => "Welcome to I am zero")
  end

  def activation_success_email(user)
    @user = user
    @url  = "#{host}login"
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end
  
  def reset_password_email(user)
    @user = user
    @url  = "#{host}password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email, :subject => "Your password has been reset")
  end

  private
  def host
    'http://' + (Rails.env == 'production' ? 'www.iamzero.in' : '0.0.0.0:3000') + '/'
  end

end
