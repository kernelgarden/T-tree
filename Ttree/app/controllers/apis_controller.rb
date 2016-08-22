class ApisController < ApplicationController
	def users
		@users=User.all
  		render :json => @users
	end

	def user_ids
		@users=User.all
  		render :json => @users.ids
	end

	def user
		@user=User.find(params[:id])
  		render :json => @user
	end

	def works
		@user=User.find(params[:id])
  		render :json => @user.works
	end

	def work_ids
		@user=User.find(params[:id])
  		render :json => @user.work_ids
	end

	def work
		@work=Work.find(params[:id])
		render :json => @work
	end

	def branches
		@work=Work.find(params[:id])
  		render :json => @work.branches
	end

	def branche_ids
		@work=Work.find(params[:id])
  		render :json => @work.branch_ids
	end

	def branch
		@branch=Branch.find(params[:id])
		render :json => @branch
	end

	def tree
		@work=Work.find(params[:id])
		@branches=@work.branches.first.subtree.arrange
  		render :json =>  Branch.json_tree(@branches)
	end

	def pages
		@branch=Branch.find(params[:id])
  		render :json => @branch.pages
	end

	def page_ids
		@branch=Branch.find(params[:id])
  		render :json => @branch.page_ids
	end

	def page
		@page=Page.find(params[:id])
		render :json => @page
	end

end
