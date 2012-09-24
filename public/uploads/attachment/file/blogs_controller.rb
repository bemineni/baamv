class BlogsController < ApplicationController

	before_filter :signedin

	def new
		#find if any old blogs that were not saved
		#before and clean up.
		@blog = nil
		@allblogs = current_user.blogs.not_saved_blogs
		@allblogs.each do |blog_to_delete|
			if !@blog
				@blog = blog_to_delete
			else
				blog_to_delete.destroy
			end
		end
		if !@blog
			@blog = current_user.blogs.build
			@blog = current_user.blogs.build
			@blog.title = "Enter the blog title"
			@blog.body = "Let your thoughts flow"
			#just for testing
			#3.times { @blog.attachments.build }
			if !@blog.save
				flash[:error] = "Could not create a new blog"
				redirect_to root_path
			end
		end

		logger.warn "#{@blog.id}"

	end

	def edit
		@blog  = current_user.blogs.find_by_id(params[:id])
		if !@blog
			#This blog doen't belong to this user
			flash[:error] = "You are not the creator of this blog"
			redirect_to root_path
		end
	end

	def update
		@blog = current_user.blogs.find_by_id(params[:id])

		if @blog
			@blog.published = true
			if @blog.update_attributes(params[:blog])
				flash[:success] = "Blog published successfully"
				redirect_to root_path
			else
				render 'edit'
			end
		else
			flash[:error] = "Was not able to find the blog."
			redirect_to root_path
		end
	end

	def index
		redirect_to root_path
	end

	def destroy

	end

end
