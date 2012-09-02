class CommonController < ApplicationController

 def getStates
  	@country = Country.find_by_id(params[:country])
 end
end
