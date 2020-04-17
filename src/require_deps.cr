require "yaml"
spec = YAML.parse(File.read(ARGV[0]))
spec["dependencies"].as_h.each do |name, value|
  puts "require \"#{name.as_s}\""
end
