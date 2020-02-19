class CreateShardDependencies
  include Clear::Migration

  def change(dir)
    create_table(:shard_dependencies, :uuid) do |t|
      t.references "shards", "parent_id", type: :uuid, null: false
      t.references "projects", "dependency_id", type: :uuid, null: false
      t.column :development, type: :boolean, default: false, null: false
      t.column :ref_requirement, :string
      t.timestamps
    end
  end
end
