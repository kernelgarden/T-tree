class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  has_many :ut_relationships, :foreign_key => "member_id", :dependent => :destroy
  has_many :teams, :through => :ut_relationships
  has_many :works, :dependent => :destroy, :foreign_key => "user_id"

  #팀 가입
  def join(team)
  	ut_relationships.create(team_id: team.id)
  end

  #팀 탈퇴
  def withdraw(team)
  	ut_relationships.find_by(team_id: team.id).destroy
  end

  #현재 사용자가 해당 팀에 가입되어있으면 true 반환
  def join?(team)
  	teams.include?(team)
  end

  def self.find_for_facebook_oauth(auth)
    if user = User.find_by_email(auth.info.email)  # search your db for a user with email coming from fb
      return user  #returns the user so you can sign him/her in
    else
      user = User.create(provider: auth.provider,    # Create a new user if a user with same email not present
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0,20],
      image: auth.info.image,
      name: auth.info.name)
      return user
    end
  end



  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(provider:auth.provider,
      uid:auth.uid,
      name: data["name"],
      email: data["email"],
      password: Devise.friendly_token[0,20]
      )
    end
    user
  end
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      else data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
        user.email=data["email"]if user.email.blank?
      end
    end
  end
  def self.search(search)
    where("email LIKE ? or name LIKE?", "%#{search}%", "%#{search}%")
  end
end
