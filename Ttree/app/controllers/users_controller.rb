class UsersController < ApplicationController
  def new
  end
  def index
  	#@branches=Branch.arrange
  	#render :json =>  Branch.json_tree(@branches)
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
      @users = User.all
      if params[:search]
        @users = User.search(params[:search]).order("created_at DESC")
      else
        @users = User.all.order('created_at DESC')
      end
  end
end
