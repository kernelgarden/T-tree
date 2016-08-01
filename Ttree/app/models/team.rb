class Team < ApplicationRecord
	has_many :ut_relationships, :foreign_key => "team_id", :dependent => :destroy
	has_many :users, :through => :ut_relationships
end
