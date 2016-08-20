class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :work_ids, :user_ids
end
