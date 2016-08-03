Rails.application.config.active_record.belongs_to_required_by_default = false

class Work < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :team, optional: true
	#순서 최근 순으로 
	#default_scope  { order(:created_at => :desc) }
	validates:name, presence:true, length:{maximum:50}

	has_many :branches, :dependent => :destroy
end
