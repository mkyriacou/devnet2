class CreateUrllinks < ActiveRecord::Migration
  def change
    create_table :urllinks do |t|
      t.integer :poll_id
      t.string :urllinks
      t.string :caption
      t.timestamps
    end
  end
end
