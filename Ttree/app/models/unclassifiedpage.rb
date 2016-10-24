Rails.application.config.active_record.belongs_to_required_by_default = false
class Unclassifiedpage < ApplicationRecord
  belongs_to :user
  #순서 최근 순으로 
  #default_scope  { order(:created_at => :desc) }
  validates:title, presence:true
  validates:user_id, presence:true

  def self.json_time(nodes)
    nodes.map do |node|
        {:id => node.id, :title => node.title, :user_id => node.user_id, :url => node.url,
         :timenum=> node.timenum,
         #:created_at => node.created_at.strftime("%Y%m%e%H%M%S"), 
         :created_at => node.created_at, 
         :time => node.created_at.strftime("%Y.%m.%e %H:%M:%S %p")}
    end
    #attributes :id, :title, :user_id, :url, :created_at
  end
end
