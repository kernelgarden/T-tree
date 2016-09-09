class UserSerializer < ActiveModel::Serializer
  attributes :id, :name,:email, :work_ids, :team_ids, :unclassifiedpage_ids
end
