class BrRelationship < ApplicationRecord
	belongs_to :highbranch, class_name: "Branch"
	belongs_to :lowbranch, class_name: "Branch"
	validates:highbranch_id, presence:true
	validates:lowbranch_id, presence:true
end
