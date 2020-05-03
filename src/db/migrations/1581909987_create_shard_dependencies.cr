class CreateShardDependencies
  include Clear::Migration

  def change(dir)
    create_table(:shard_dependencies) do |t|
      t.references "shards", "parent_id", null: false, on_delete: "CASCADE"
      t.references "projects", "dependency_id", null: false, on_delete: "CASCADE"
      t.column :name, :string, index: true, null: false
      t.column :ref_type, :ref_type, index: true
      t.column :ref_name, :string, index: true
      t.column :requirement_operator, :string
      t.column :requirement_version, :string, index: true
      t.column :development, type: :boolean, default: false, null: false

      t.index [:parent_id, :name, :dependency_id], unique: true

      t.timestamps
    end
  end
end
