class UsersController < ApplicationController
  def new
  end
  def index
  	@users=Branch.all
  	#render json: @users
  	render :json =>  Branch.json_tree(@users)
  end
end
