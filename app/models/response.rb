class Response < ActiveRecord::Base
  attr_accessible :reviewer_id, :question_id, :question_type, :response_text

  belongs_to :vote_question, foreign_key: :question_id
  belongs_to :user, foreign_key: :reviewer_id

  belongs_to :text_question

end
