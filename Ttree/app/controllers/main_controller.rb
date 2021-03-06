class MainController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :logged_in_user, only: [:home]
	before_action :logged_in_user, only: [:login]
	before_action :check_login, only: [:home]
	before_action :check_authenticity, only: [:folderView]

	include MainHelper

	def home
		#@star_lists = current_user.starlists.pluck(:work_id)
	end

	def pages
		@user=current_user
		@user_id=@user.id
	end

	def work
		@work_id=params[:id]
		@page_ids=User.current.unclassifiedpage_ids
	end


	def login
	end

	def branchPages
	end

	def team
		@team_id=params[:id]
		@team=Team.find(@team_id)
	end

	def temp

	end

	def folderView
		@uri = params[:uri]
		@work = @uri.split("/").first
		@firstBranch=Work.find(@work).first_branch
		@workname=Work.find(@work).name
		@treeViewWidth=Work.find(@work).viewwidth
		#@work_obj = Work.find(@work)
		#@isTeam = Work.find(@work).team_id != nil
		#@type = (@work_obj.team_id != nil)? "team" : "personal"
		@branch = @uri.split("/")[1..-1]
		if @branch.empty? # work인 경우
			@child_branches = Branch.where(work_id: @work, ancestry: nil)
		else # branch인 경우
			@branch_id=@branch.last;
			@child_branches = Branch.where("ancestry = ?", @branch.join("/"))
			@child_pages = Page.where("branch_id = ?", @branch.last)
			@ancestry = @branch.join("/")
		end

	end

	def sharefolder
		@uri = params[:uri]
		@work = @uri.split("/").first
		@firstBranch=Work.find(@work).first_branch
		@workname=Work.find(@work).name
		@treeViewWidth=Work.find(@work).viewwidth
		#@work_obj = Work.find(@work)
		#@isTeam = Work.find(@work).team_id != nil
		#@type = (@work_obj.team_id != nil)? "team" : "personal"
		@branch = @uri.split("/")[1..-1]
		if @branch.empty? # work인 경우
			@child_branches = Branch.where(work_id: @work, ancestry: nil)
		else # branch인 경우
			@branch_id=@branch.last;
			@child_branches = Branch.where("ancestry = ?", @branch.join("/"))
			@child_pages = Page.where("branch_id = ?", @branch.last)
			@ancestry = @branch.join("/")
		end
	end

	private
	def logged_in_user
		if current_user
			redirect_to root_url
		end
	end
	def check_login
		if current_user==nil
			redirect_to main_login_url
		end
	end
	def check_authenticity
		uri = params[:uri].split("/")

		if uri.length == 1
			return render_404 if !Work.exists?(uri.first)
		elsif uri.length > 1
			return render_404 if !Branch.exists?(uri.last)
		end

		work_id = uri.first
		root = Work.find(work_id)
		teams = UtRelationship.where("member_id = ?", current_user).map(&:team_id)
		if !root.team_id && root.user_id && current_user.id != root.user_id
			redirect_to root_url
		elsif root.team_id && root.team_id && !teams.include?(root.team_id)
			redirect_to root_url
		end
	end
end
