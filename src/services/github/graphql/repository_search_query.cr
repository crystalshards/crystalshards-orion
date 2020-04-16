require "./repository"

class Service::Github::GraphQL::RepositorySearchQuery
  class Response
    JSON.mapping(
      data: RepositorySearchQuery
    )
  end

  JSON.mapping(
    search: Connection(Service::Github::GraphQL::Repository),
    rate_limit: {type: RateLimit, key: "rateLimit"}
  )

  QUERY = <<-graphql
  query ($query: String!, $first: Int, $after: String) {
    search(type: REPOSITORY, query: $query, first: $first, after: $after) {
      edges {
        cursor
        node {
          ...repo_fragment
        }
      }
    }
  }
  #{Service::Github::GraphQL::Repository::FRAGMENT}
  graphql

  def self.fetch(*, language = "Crystal", pushed_before : Time? = nil, first : Int32? = nil, after : String? = nil)
    query_parts = ["language:#{language}"]
    query_parts.push("pushed:<=#{pushed_before.to_s("%F")}") if pushed_before

    body = {
      query:     QUERY,
      variables: {
        query: query_parts.join(" "),
        first: first,
        after: after,
      },
    }.to_json
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    response = HTTP::Client.post(url, headers, body)
    Response.from_json(response.body).data
  end
end
