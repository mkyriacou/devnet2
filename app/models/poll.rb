class Poll < ActiveRecord::Base
  attr_accessible :project_id, :title, :description, :category, :real_time

  belongs_to :project

  has_many :responses, through: :vote_question
  has_many :responses, through: :text_question # IS THIS CORRECT???
  has_many :vote_questions
  has_many :text_questions
  has_many :urllinks

end
