class CreateUrllinks < ActiveRecord::Migration
  def change
    create_table :urllinks do |t|

      t.timestamps
    end
  end
end
