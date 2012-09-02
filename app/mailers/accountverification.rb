class Accountverification < ActionMailer::Base
  default from: "srikanth.bemineni@gmail.com"

  def verify(userto)
  	@user = userto
  	mail(:to => userto.email, :subject => "Thank you for registering with #{APPNAME}.") do |format|
  		format.html
  	end
  end
end
