class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :reviewer_id
      t.integer :poll_id
      t.integer :question_id
      t.string :question_type
      t.text :response
      t.timestamps
    end
  end
end
