require "./converters/**"

Clear::Model::Converter.add_converter("SemanticVersion", SemanticVersionConverter)
