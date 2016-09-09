class WorkSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :team_id, :branch_ids
  has_many :starlists
end
