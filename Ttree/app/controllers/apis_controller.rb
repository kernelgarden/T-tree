class ApisController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :getWork, :only => [:getWork1]

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

	def teams
		@user=User.find(params[:id])
  		render :json => @user.teams
	end

	def team
		@team=Team.find(params[:id])
  		render :json => @team
	end


	def teamworks
		@team=Team.find(params[:id])
  		render :json => @team.works
	end

	def teamwork_ids
		@team=Team.find(params[:id])
  		render :json => @team.work_ids
	end

	def member_ids
		@team=Team.find(params[:id])
  		render :json => @team.user_ids
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

	def branchChilds
			@branch=Branch.find(params[:id])
  		render :json => @branch.children
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

	def unclassifiedpage
		@unclassifiedpage=Unclassifiedpage.find(params[:id])
		render :json => @unclassifiedpage
	end

	def unclassifiedpages
		@user=User.find(params[:id])
  		render :json => @user.unclassifiedpages
	end

	def getWork
		#@work=(params[:work])
		Work.create(work_params)
  		#render :json => @work
	end
	def getTeam
		@team=Team.create(team_params)
		User.current.join(@team)
	end

	def getPages

		@json= JSON.parse(request.raw_post)
		@user= User.find_by_email(@json["user_email"])
		@json["pages"].each do |page|
			Unclassifiedpage.create(:user_id=>@user.id, :title=>page["title"], :url=>page["url"])
		end

	end

	private
	def work_params
		params.require(:work).permit(:name, :user_id, :team_id, :branch_ids)
	end
	def team_params
		params.require(:team).permit(:name)
	end
end
