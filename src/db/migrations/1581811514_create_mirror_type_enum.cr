class CreateMirrorTypeEnum
  include Clear::Migration

  def change(dir)
    create_enum(:mirror_type, %w(mirror fork legacy similar))
  end
end
