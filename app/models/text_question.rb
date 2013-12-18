  class TextQuestion < ActiveRecord::Base
  attr_accessible :poll_id, :question_text

  belongs_to :poll

  has_many :responses

end
