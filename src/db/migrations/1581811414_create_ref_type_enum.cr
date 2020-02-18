class CreateRefTypeEnum
  include Clear::Migration

  def change(dir)
    create_enum(:ref_type, %w(version tag branch commit))
  end
end
