class CreateBanters < ActiveRecord::Migration
  def change
    create_table :banters do |t|

      t.timestamps
    end
  end
end
