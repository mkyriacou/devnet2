class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.integer :project_id
      t.string :title
      t.string :description
      t.string :category
      t.boolean :real_time
      t.timestamps
    end
  end
end
