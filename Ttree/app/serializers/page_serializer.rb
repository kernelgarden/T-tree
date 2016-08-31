class PageSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :branch_id
end
