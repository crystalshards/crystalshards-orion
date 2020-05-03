class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards) do |t|
      t.column :manifest, :jsonb, null: false
      t.column :name, :string, index: true, null: false
      t.column :version, :string, index: true, null: false
      t.column :index, :boolean, default: true, null: false
      t.column :readme, :text
      t.column :git_tag, :string, index: true
      t.column :license, :string, index: true
      t.column :pushed_at, "timestamp without time zone"
      t.column :description, :string
      t.column :crystal, :string
      t.column :tags, :string, array: true, null: false, default: "'{}'"

      t.full_text_searchable on: [{"name", 'A'}, {"description", 'B'}]

      t.references "projects", null: false, on_delete: "CASCADE"

      t.timestamps
    end
  end
end
