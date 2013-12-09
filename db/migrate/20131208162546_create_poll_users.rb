class CreatePollUsers < ActiveRecord::Migration
  def change
    create_table :poll_users do |t|

      t.timestamps
    end
  end
end
