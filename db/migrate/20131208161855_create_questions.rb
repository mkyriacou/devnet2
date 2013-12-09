class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.poll_id
      t.question_text
      t.timestamps
    end
  end
end
