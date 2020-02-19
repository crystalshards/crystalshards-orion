class CreateShardDependencies
  include Clear::Migration

  def change(dir)
    create_table(:shard_dependencies, :uuid) do |t|
      t.references "shards", type: :uuid, null: false, foreign_key: "parent_id"
      t.references "projects", type: :uuid, null: false, foreign_key: "dependency_id"
      t.column :development, type: :boolean, default: false, null: false
      t.column :ref_requirement, :string
      t.timestamps
    end
  end
end
