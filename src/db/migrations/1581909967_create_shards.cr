class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards, :uuid) do |t|
      t.column :manifest, :jsonb, null: false
      t.column :name, :string, index: true, null: false
      t.column :version, :string, index: true, null: false
      t.column :license, :string, index: true
      t.column :description, :string
      t.column :crystal, :string
      t.column :tags, :string, array: true

      t.references "projects", type: :uuid, null: false

      t.timestamps
    end
  end
end
