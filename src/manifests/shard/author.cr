require "../string_parser.cr"

class Manifest::Shard::Author
  include StringParser

  property name : String
  property email : String?

  def initialize(name)
    if name =~ /\A\s*(.+?)\s*<+(\s*.+?\s*)>+/
      @name, @email = $1, $2
    else
      @name = name
    end
  end

  def name_is_username?
    !name.includes?(" ")
  end

  def to_yaml(builder)
    (email ? "#{name} <#{email}>" : name).to_yaml(builder)
  end

  def to_json(builder)
    (email ? "#{name} <#{email}>" : name).to_json(builder)
  end
end
