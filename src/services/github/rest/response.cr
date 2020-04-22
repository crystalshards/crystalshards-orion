class Service::Github::REST::Response(T)
  def self.fetch(endpoint : String, **key_values)
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    params = key_values.map { |k, v| [k, v].join("=") }.join("&")
    url = "https://api.github.com/search/#{endpoint}?" + params
    response = HTTP::Client.get(url, headers)
    puts "REST Request (#{T.name}):"
    puts "URL:", url.colorize(:dark_gray)
    puts "Response: #{response.status_code.colorize(response.status_code == 200 ? :light_green : :light_red)}"
    raise Exception.new("Bad response: #{response.body}") if response.status_code != 200
    T.from_json(response.body)
  end
end
