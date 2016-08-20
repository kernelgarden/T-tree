class MainController < ApplicationController
    before_action :logged_in_user, only: [:home]

  def home
  end

  def pages
  end

  def work
  end

  def login
  end

  def branchPages
  end

  def team
  end
  
  private
  def logged_in_user
    unless user_signed_in?
      redirect_to main_login_url
    end
  end
end