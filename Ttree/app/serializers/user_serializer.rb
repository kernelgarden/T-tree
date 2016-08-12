class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :work_ids, :team_ids
end
