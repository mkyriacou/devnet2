class CreateBuddies < ActiveRecord::Migration
  def change
    create_table :buddies do |t|

      t.timestamps
    end
  end
end
