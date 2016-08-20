class WorkSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :team_id, :branch_ids
end
