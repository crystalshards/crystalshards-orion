module ViewHelper
  def pluralize(count : Int, word : String)
    word = count == 1 ? Wordsmith::Inflector.singularize(word) : Wordsmith::Inflector.pluralize(word)
    "#{count} #{word}"
  end

  def update_params(*args, **params)
    next_params = HTTP::Params.parse(request.query_params.to_s)
    params.each do |key, value|
      if value
        next_params[key.to_s] = value
      else
        next_params.delete_all(key.to_s)
      end
    end
    [request.path, next_params.to_s].reject(&.empty?).join("?")
  end
end
