class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :works
  has_many :users, :through => :ut_relationships
end
