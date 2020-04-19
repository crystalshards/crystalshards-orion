class CreateProjects
  include Clear::Migration

  def change(dir)
    create_table(:projects, :uuid) do |t|
      t.column :api_id, :string, null: false, index: true
      t.column :provider, :provider, null: false
      t.column :uri, :string, null: false
      t.column :watcher_count, :integer, null: false, default: 0
      t.column :fork_count, :integer, null: false, default: 0
      t.column :star_count, :integer, null: false, default: 0
      t.column :pull_request_count, :integer, null: false, default: 0
      t.column :issue_count, :integer, null: false, default: 0
      t.column :mirror_type, :mirror_type
      t.references "projects", "mirrored_id", type: :uuid, null: true

      t.timestamps

      t.index [:api_id, :provider], unique: true
    end
  end
end
