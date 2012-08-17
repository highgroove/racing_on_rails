class TurnPeopleRolesHabtmIntoHasManyThrough < ActiveRecord::Migration
  def up
    rename_table :people_roles, :role_assignments
    add_column :role_assignments, :id, :primary_key
    add_column :role_assignments, :created_at, :datetime
    add_column :role_assignments, :updated_at, :datetime
  end

  def down
    rename_table :role_assignments, :people_roles
    remove_column :role_assignments, :id
    remove_column :role_assignments, :created_at
    remove_column :role_assignments, :updated_at
  end
end
