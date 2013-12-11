class Banter < ActiveRecord::Base
  attr_accessible :response_id, :developer_id, :reviewer_id, :text

  belongs_to :response
end
