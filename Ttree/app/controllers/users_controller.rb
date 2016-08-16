class UsersController < ApplicationController
  def new
  end
  def index
  	@branches=Branch.arrange
  	render :json =>  Branch.json_tree(@branches)
  	#@works=Work.all
  	#render :json => @works
  	#@pages=Page.all
  	#render :json => @pages
  	#@users=User.all
  	#render :json => @users
  end
  def show
  end
  def profile
  end

end
