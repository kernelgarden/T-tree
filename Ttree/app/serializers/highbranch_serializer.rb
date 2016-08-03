class HighbranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :lowbranches

  has_many :lowbranches, serializer: BranchSerializer
  #has_many :highbranches, serializer: BranchSerializer
end
