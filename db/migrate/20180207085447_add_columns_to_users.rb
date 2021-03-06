class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uid, :string, unique: true
    add_column :users, :username, :string, default: "anonymous"
  end
end
