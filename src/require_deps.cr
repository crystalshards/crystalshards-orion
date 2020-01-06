require "shards/spec"
spec = Shards::Spec.from_yaml(File.read("./shard.yml"))

spec.dependencies.each do |dep|
  puts "require \"#{dep.name}\""
end

