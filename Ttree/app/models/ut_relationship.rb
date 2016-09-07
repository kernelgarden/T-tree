class UtRelationship < ApplicationRecord
	belongs_to :member, class_name: "User"
	belongs_to :team, class_name: "Team"
	validates:member_id, presence:true
	validates:team_id, presence:true
	after_destroy:check_user

	private
	def check_user
		@team_id=self.team_id
		@team=Team.find(@team_id)
		if(@team.user_ids[0]==nil)
			@team.destroy
		end
	end

end
