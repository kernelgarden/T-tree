class Branch < ApplicationRecord
  	belongs_to :work
  	#순서 최근 순으로 
  	#default_scope  { order(:created_at => :desc) }
  	validates:name, presence:true, length:{maximum:50}
  	validates:work_id, presence:true

  	has_many :make_relationships, :class_name => "BrRelationship", 
  									:foreign_key => "highbranch_id", 
  									:dependent => :destroy
  	has_many :made_relationships, :class_name => "BrRelationship", 
  									:foreign_key => "lowbranch_id", 
  									:dependent => :destroy
  	has_many :lowbranches, :through => :make_relationships
  	has_many :highbranchs, :through => :made_relationships

  	has_many :pages, :dependent => :destroy

  	#하위 가지와 연결
	def connect(other_branch)
		make_relationships.create(lowbranch_id:other_branch.id)
	end

	#하위 가지를 제거
	def disconnect(other_branch)
		make_relationships.find_by(lowbranch_id:other_branch.id).destroy
	end

	#현재 가지가 해당 가지를 하위가지로 가지고 있으면 true 반환
	def connect?(other_branch)
		lowbranches.include?(other_branch)
	end
	def self.json_tree(branches)
	    branches.map do |branch, lowbranches|
	      {:name => branches.name, :lowbranches => Branch.json_tree(lowbranches).compact}
	    end
	end
end
