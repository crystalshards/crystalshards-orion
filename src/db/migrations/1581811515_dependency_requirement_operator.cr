class CreateDependencyReqOperatorEnum
  include Clear::Migration

  def change(dir)
    create_enum(:dependency_requirement_operator, %w{lt lte gt gte gtir})
  end
end
