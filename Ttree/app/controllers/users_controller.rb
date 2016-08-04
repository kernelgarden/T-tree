class UsersController < ApplicationController
  def new
  end
  def index
  	#@branches=Branch.arrange
  	#render :json =>  Branch.json_tree(@branches)
  	@works=Work.all
  	render :json => @works
  end


end
