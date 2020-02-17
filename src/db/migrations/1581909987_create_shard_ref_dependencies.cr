class CreateShardRefDependencies
  include Clear::Migration

  def change(dir)
    create_table(:shard_ref_dependencies, :uuid) do |t|
      t.references "shard_refs", type: :uuid, null: false
      t.references "shards", type: :uuid, null: false
      t.column :development, type: :boolean, default: false, null: false
      t.column :provider, :provider, null: false
      t.column :provider_uri, :string, null: false
      t.column :ref_type, :ref_type
      t.column :ref_value, :string
      t.timestamps
    end
  end
end
