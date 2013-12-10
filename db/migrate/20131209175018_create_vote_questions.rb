class CreateVoteQuestions < ActiveRecord::Migration
  def change
    create_table :vote_questions do |t|
      t.integer :poll_id
      t.string :preamble
      t.string :up_vote_label
      t.string :neutral_vote_label
      t.string :down_vote_label
      t.timestamps
    end
  end
end
