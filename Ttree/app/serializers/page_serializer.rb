class PageSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :branch
end
