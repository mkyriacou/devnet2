class Project < ActiveRecord::Base
  attr_accessible :user_id, :title, :description, :public_proj

  belongs_to :user

  has_many :polls
end
