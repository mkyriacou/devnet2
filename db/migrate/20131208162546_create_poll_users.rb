class CreatePollUsers < ActiveRecord::Migration
  def change
    create_table :poll_users do |t|
      t.integer :poll_id
      t.integer :user_id
      t.integer :stars_awarded
      t.timestamps
    end
  end
end
