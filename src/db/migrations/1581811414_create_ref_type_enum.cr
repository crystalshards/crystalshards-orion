class CreateRefTypeEnum
  include Clear::Migration

  def change(dir)
    create_enum(:ref_type, %w(tag branch commit))
  end
end
