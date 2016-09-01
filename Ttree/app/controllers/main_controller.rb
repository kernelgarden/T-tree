class MainController < ApplicationController
		skip_before_action :verify_authenticity_token
    before_action :logged_in_user, only: [:home]

  def home
  end

  def pages
  end

  def work
  	@work_id=params[:id]
  end


  def login
  end

  def branchPages
  end

  def team
		@team_id=params[:id]
		@team=Team.find(@team_id)
  end

  private
  def logged_in_user
    unless user_signed_in?
      redirect_to main_login_url
    end
  end
end
