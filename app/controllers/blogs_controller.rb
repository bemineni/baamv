class BlogsController < ApplicationController

	before_filter :check_login

	def new
		#find if any old blogs that were not saved
		#before and clean up.
		@blog = current_user.blogs.build(:published=>true)
		@blog.title = "Enter the blog title"
		@blog.body = "Let your thoughts flow"
		#just for testing
		#3.times { @blog.attachments.build }

	end

	def edit
		@blog  = current_user.blogs.find_by_id(params[:id])
		if !@blog
			#This blog doen't belong to this user
			flash[:error] = "You are not the creator of this blog"
			redirect_to root_path
		end
	end

	def create
		@blog = current_user.blogs.build(params[:blog])
		if @blog.save
				flash[:success] = "Blog published successfully"
				redirect_to root_path
		else
			flash[:error] = "Was not able to find the blog."
			redirect_to root_path
		end
	end

	def update
		 if @blog.update_attributes(params[:blog])
      			redirect_to @ad_listing, :notice  => "Successfully updated the blog."
    	 else
      		 	render :action => 'edit'
    	 end
	end

	def index
		redirect_to root_path
	end

	def destroy

	end

end
