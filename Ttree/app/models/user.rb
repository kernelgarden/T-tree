class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ut_relationships, :foreign_key => "member_id", :dependent => :destroy

  has_many :teams, :through => :ut_relationships

  #팀 가입
  def join(team)
  	ut_relationships.create(team_id: team.id)
  end

  #팀 탈퇴
  def withdraw(team)
  	ut_relationships.find_by(team_id: team.id).destroy
  end

  #왜 안되지 
  def join?(team)
  	teams.include?(team)
  end
end
