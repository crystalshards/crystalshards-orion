class ShardDependency
  include Clear::Model

  primary_key
  column name : String
  column ref_type : RefType?
  column ref_name : String?
  column requirement_operator : Manifest::Shard::Dependency::Requirement::Operator?
  column requirement_version : String?
  column development : Bool

  belongs_to shard : Shard, foreign_key: "parent_id"
  belongs_to dependency : Project, foreign_key: "dependency_id"

  def self.associate(parent : Shard, name : String, dependency : Manifest::Shard::Dependency::Provider, development : Bool = false)
    if (uri = dependency.uri)
      project = Project.query.find_or_create({provider: dependency.provider, uri: uri}) { }
      query.find_or_create({parent_id: parent.id, name: name, dependency_id: project.id, development: false}) do |dep|
        if (ref_type = dependency.ref_type)
          dep.ref_type = RefType.from_string(ref_type)
        end
        dep.requirement_operator = dependency.version.try(&.operator)
        dep.requirement_version = dependency.version.try(&.version)
        dep.ref_name = dependency.ref_name
        dep.development = development
      end
    end
  end
end
