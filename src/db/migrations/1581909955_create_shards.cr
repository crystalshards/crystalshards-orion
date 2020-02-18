class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards, :uuid) do |t|
      t.column :provider, :provider, null: false
      t.column :provider_uri, :provider, null: false
      t.column :watcher_count, :integer, null: false, default: 0
      t.column :fork_count, :integer, null: false, default: 0
      t.column :star_count, :integer, null: false, default: 0
      t.column :pull_request_count, :integer, null: false, default: 0
      t.column :issue_count, :integer, null: false, default: 0
      t.timestamps

      t.full_text_searchable on: [{"name", 'A'}]
    end
  end
end
