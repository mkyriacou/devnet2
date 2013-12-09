class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :poll_id
      t.string :description
      t.string :up_vote_label
      t.string :neutral_vote_label
      t.string :down_vote_label

      t.timestamps
    end
  end
end
