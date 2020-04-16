class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards, :uuid) do |t|
      t.references "projects", type: :uuid, null: false
      t.column :ref_type, :ref_type, index: true, null: false
      t.column :ref_name, :string, index: true, null: false
      t.column :spec_json
      t.timestamps
    end
  end
end
