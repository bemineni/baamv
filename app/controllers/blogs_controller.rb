class BlogsController < ApplicationController

	before_filter :signedin

	def new
		@blog = Blog.new
	end

	def create

		@blog = current_user.blogs.build(params[:blog])
		if @blog and @blog.save
			flash[:success] = "Blog saved sucessfully"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
		@blog  = current_user.blogs.find_by_id(params[:id])
		if !blog
			#This blog doen't belong to this user
			flash[:error] = "You are not the creator of this blog"
			redirect_to root_path
		end

	end

	def index
		redirect_to root_path
	end

	def destroy

	end

end
