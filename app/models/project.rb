class Project < ActiveRecord::Base
  attr_accessible :user_id, :title, :description

  belongs_to :user

  has_many :polls
end
