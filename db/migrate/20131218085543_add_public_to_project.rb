class AddPublicToProject < ActiveRecord::Migration
  def change
   add_column :projects, :public_proj, :boolean
  end
end
