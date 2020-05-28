class Service::Github::GraphQL::Response(T)
  class Error
    class Location
      JSON.mapping(
        line: Int32,
        column: Int32
      )
    end

    JSON.mapping(
      message: String,
      locations: Array(Location)?
    )
  end

  JSON.mapping(
    data: T?,
    errors: Array(Error)?
  )

  def self.fetch(*args, **variables) : T
    fetch(variables)
  end

  def self.fetch(variables) : T
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    body = {
      query:     T::QUERY,
      variables: variables,
    }.to_json
    Log.debug { "GraphQL Request (#{T.name}):" }
    Log.debug { "VARIABLES:\n#{variables.to_pretty_json.colorize(:dark_gray)}" }
    Log.debug { "QUERY:\n#{T::QUERY.colorize(:dark_gray)}" }
    response = HTTP::Client.post(url, headers, body)
    Log.debug { "Response: #{response.status_code.colorize(response.status_code == 200 ? :light_green : :light_red)}" }
    raise Exception.new("Bad response #{response.status_code}: #{response.body}") if response.status_code != 200
    response = from_json(response.body)
    if (response.errors)
      message = response.errors.try(&.map(&.message).join(", "))
      raise "GraphQL Error: #{message}"
    end
    return response.data.not_nil!
  end
end
