class UnclassifiedpageSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :url, :created_at
end
