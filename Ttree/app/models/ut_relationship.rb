class UtRelationship < ApplicationRecord
	belongs_to :member, class_name: "User"
	belongs_to :team, class_name: "Team"
	validates:member_id, presence:true
	validates:team_id, presence:true
end
