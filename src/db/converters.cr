require "./converters/**"

Clear::Model::Converter.add_converter("SemanticVersion", SemanticVersionConverter)
Clear::Model::Converter.add_converter("Manifest::Shard", Manifest::Shard)
