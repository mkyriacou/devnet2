class CreateTextQuestions < ActiveRecord::Migration
  def change
    create_table :text_questions do |t|
      t.integer :poll_id
      t.text :question_text
      t.timestamps
    end
  end
end
