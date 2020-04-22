class CreateProjects
  include Clear::Migration

  def change(dir)
    create_table(:projects) do |t|
      t.column :provider, :provider, null: false
      t.column :uri, :string, null: false
      t.column :api_id, :string, index: true
      t.column :watcher_count, :integer, null: false, default: 0
      t.column :fork_count, :integer, null: false, default: 0
      t.column :star_count, :integer, null: false, default: 0
      t.column :pull_request_count, :integer, null: false, default: 0
      t.column :issue_count, :integer, null: false, default: 0
      t.column :mirror_type, :mirror_type
      t.references "projects", "mirrored_id", null: true

      t.timestamps

      t.index [:provider, :uri], unique: true
      t.index [:provider, :api_id], unique: true
    end
  end
end
