class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :pages, :lowbranches
  belongs_to :work
  has_many :lowbranches, serializer: HighbranchSerializer
  has_many :pages, serializer: PageSerializer


end