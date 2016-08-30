class Team < ApplicationRecord
	has_many :ut_relationships, :foreign_key => "team_id", :dependent => :destroy
	has_many :users, :through => :ut_relationships, :source => :member

	has_many :works, :dependent => :destroy, :foreign_key => "team_id"
	validates:name, presence:true, length:{maximum:15}
end
