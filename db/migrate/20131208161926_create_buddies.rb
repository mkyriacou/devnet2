class CreateBuddies < ActiveRecord::Migration
  def change
    create_table :buddies do |t|
      t.integer :developer_id
      t.integer :review_id
      t.timestamps
    end
  end
end
