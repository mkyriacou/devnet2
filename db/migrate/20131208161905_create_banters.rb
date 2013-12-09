class CreateBanters < ActiveRecord::Migration
  def change
    create_table :banters do |t|
      t.integer :poll_user_id
      t.integer :developer_id
      t.integer :reviewer_id
      t.text :text
      t.timestamps
    end
  end
end
