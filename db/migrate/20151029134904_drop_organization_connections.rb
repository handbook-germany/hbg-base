class DropOrganizationConnections < ActiveRecord::Migration[4.2]
  def change
    drop_table :organization_connections do |t|
      t.integer "parent_id", null: false
      t.integer "child_id",  null: false
    end
  end
end
