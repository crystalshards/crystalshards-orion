class CreateProjects
  include Clear::Migration

  def change(dir)
    create_table(:projects) do |t|
      t.column :provider, :provider, null: false
      t.column :uri, :string, null: false
      t.column :api_id, :string, index: true
      t.column :description, :string
      t.column :homepage, :string
      t.column :watcher_count, :integer
      t.column :pushed_at, "timestamp without time zone"
      t.column :star_count, :integer
      t.column :pull_request_count, :integer
      t.column :issue_count, :integer
      t.column :tags, :string, array: true, null: false, default: "'{}'"
      t.column :mirror_type, :mirror_type
      t.references "projects", "mirrored_id", null: true, on_delete: "SET NULL"

      t.timestamps

      t.index [:provider, :uri], unique: true
      t.index [:provider, :api_id], unique: true
    end
  end
end
