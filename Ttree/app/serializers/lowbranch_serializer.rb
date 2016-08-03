class LowbranchSerializer < BranchSerializer
  attributes :id

  has_many :highbranches, :class_name => "Branch", :through => :made_relationships
end
