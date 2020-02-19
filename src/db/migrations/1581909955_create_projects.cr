class CreateProjects
  include Clear::Migration

  def change(dir)
    create_table(:projects, :uuid) do |t|
      t.column :provider, :provider, null: false
      t.column :uri, :provider, null: false
      t.column :watcher_count, :integer, null: false, default: 0
      t.column :fork_count, :integer, null: false, default: 0
      t.column :star_count, :integer, null: false, default: 0
      t.column :pull_request_count, :integer, null: false, default: 0
      t.column :issue_count, :integer, null: false, default: 0
      t.column :mirror_type, :mirror_type
      t.references "projects", "mirrored_id", type: :uuid
      t.timestamps
    end
  end
end
