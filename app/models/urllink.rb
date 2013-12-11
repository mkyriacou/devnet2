class Urllink < ActiveRecord::Base
  attr_accessible :poll_id, :urllinks, :caption

  belongs_to :poll
end
