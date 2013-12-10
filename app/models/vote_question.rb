class VoteQuestion < ActiveRecord::Base
  attr_accessible :poll_id, :preamble, :up_vote_label, :neutral_vote_label, :down_vote_label

  belongs_to :poll
  has_many :responses
end
