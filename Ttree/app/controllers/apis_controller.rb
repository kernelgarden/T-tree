class ApisController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :getWork, :only => [:getWork1]
	#before_action :treeViewStatus, :only => [:tree]

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

	def branchesByParent
		if params[:id2]=="null"
			@branches=Branch.where(:work_id=>params[:id]).roots
		else
			@parent=Branch.find(params[:id2])
			@branches=Branch.children_of(@parent)
		end
		render :json => @branches
	end

	def branchesByParentandPosition
		if params[:id2]=="null"
			@branches=Branch.where(:work_id=>params[:id], :position=>params[:id3]).roots
		else
			@parent=Branch.find(params[:id2])
			@branches=Branch.children_of(@parent).where(:position=>params[:id3])
		end
		render :json => @branches
	end

	def branche_ids
		@work=Work.find(params[:id])
		render :json => @work.branch_ids
	end

	def branch
		@branch=Branch.find(params[:id])
		render :json => @branch
	end

	def treeViewWidth
		Work.find(params[:id]).update_attributes(:viewwidth=>params[:viewwidth])
		#debugger
	end 

	def treeViewStatus
		if(params[:state]=="true")
			Branch.find(params[:id]).update_attributes(:viewstate=>true)
		elsif (params[:state]=="false")
			Branch.find(params[:id]).update_attributes(:viewstate=>false)
		end
	end

	def tree
		@work=Work.find(params[:id])
		#@branches=Branch.all
		#mappings = {"name" => "title"}

		#@branches=@work.branches.arrange_serializable
		@branches=@work.branches
		render :json =>Branch.json_search(@branches)

		#render :json => @branches
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
		#render :json => @user.unclassifiedpages
		render :json => Unclassifiedpage.json_time(@user.unclassifiedpages)
	end

	def getWork
		#@work=(params[:work])
		@work=Work.create(work_params)
		@work.update_attributes(:viewwidth=>140)
		#render :json => @work
	end
	def getTeam
		@team=Team.create(team_params)
		User.current.join(@team)
	end

	def getPages
		@json= JSON.parse(request.raw_post)
		@user= User.find_by_email(@json["user_email"])
		@time=Time.now
		@json["pages"].each do |page|
			@thisPage=Unclassifiedpage.create(:user_id=>@user.id, :title=>page["title"], :url=>page["url"], :timenum=>@time)
			#@thisPage.update_attributes(:timenum => @time)
		end
		#debugger
	end

	def getMember
		@team_id=params[:team_id]
		@user_id=params[:user_id]
		User.find(@user_id).join(Team.find(@team_id))
	end

	def teamWithdraw
		@team_id=params[:team_id]
		@user_id=params[:user_id]
		User.find(@user_id).withdraw(Team.find(@team_id))
	end

	def workDelete
		@work_id=params[:work_id]
		Work.find(@work_id).destroy
	end

	def branchName
		@name=branch_params
		@branch=Branch.create(branch_params)


		#동그라미를 드롭다운했으면 저장된 전체 페이지들을 다 브렌치에 넣고 모두 삭제
		if params[:timenum]=="0"
			@pages=User.find(params[:user_id]).unclassifiedpage_ids
			Unclassifiedpage.transaction do
				@pages.each do |page|
					@page=Unclassifiedpage.find(page)
					@branch.transaction do
						@branch.pages.create(title: @page.title, url:@page.url)
					end
				end
			end
			Unclassifiedpage.transaction do
				Unclassifiedpage.where(:user_id=>params[:user_id]).delete_all
			end

		#pageCntBox를 드롭다운했으면 해당 회차의 페이지들만 브렌치에 넣고 해당페이지만 삭제
		else
			Unclassifiedpage.transaction do
				@pages=Unclassifiedpage.where(:user_id=>params[:user_id], :timenum=>params[:timenum])
				@pages.each do |page|
					@page=Unclassifiedpage.find(page)
					@branch.transaction do
						@branch.pages.create(title: @page.title, url:@page.url)
					end
				end
			end
			Unclassifiedpage.transaction do
				Unclassifiedpage.where(:user_id=>params[:user_id], :timenum=>params[:timenum]).delete_all
			end
		end #if-else

	end

	def branchName2
		@branch=Branch.find(params[:branch_id])
		@name=params[:name]
		@branch.update_attributes(:name => @name)
	end
	def workName
		@work=Work.find(params[:work_id])
		@name=params[:name]
		@work.update_attributes(:name=>@name)
	end
	def staring
		@user = User.find(params[:starlists][:user_id])
		@user.staring(Work.find(params[:starlists][:work_id]))
	end

	def unstaring
		@user = User.find(params[:starlists][:user_id])
		@user.unstaring(Work.find(params[:starlists][:work_id]))
	end

	def setStar
		Starlist.create(starlist_params)
	end

	def deleteunclassifiedpages
		#debugger
		Unclassifiedpage.find(params[:id]).destroy
		#debugger
	end

	def deletePages
		Page.find(params[:id]).destroy
	end

	def addFolder
		#debugger
		@branch=Branch.create(folder_params)
		@branch.update_attributes(:viewstate=>false)
	end

	def treeSideBar
		render :json => '[{ "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },{ "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },{ "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },{ "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" }]'
	end


	private
	def work_params
		params.require(:work).permit(:name, :user_id, :team_id, :branch_ids)
	end
	def team_params
		params.require(:team).permit(:name)
	end
	def branch_params
		params.require(:branch).permit(:name, :work_id, :parent_id, :position)
	end
	def folder_params
		params.require(:folder).permit(:name, :work_id, :ancestry)
	end
	def starlist_params
		params.require(:starlists).permit(:work_id, :user_id)
	end
end
