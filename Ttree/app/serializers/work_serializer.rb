class WorkSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :user
  has_many :branches
end
