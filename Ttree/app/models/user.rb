class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
end
