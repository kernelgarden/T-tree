class BrRelationshipSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :lowbranch
end
