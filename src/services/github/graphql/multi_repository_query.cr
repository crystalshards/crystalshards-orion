require "./repository"

class Github::GraphQL::MultiRepositoryQuery
  class Response
    JSON.mapping(
      data: MultiRepositoryQuery
    )
  end

  JSON.mapping(
    repos: Array(Repository),
    rate_limit: {type: Github::GraphQL::RateLimit, key: "rateLimit"}
  )

  QUERY = <<-graphql
  query ($node_ids: [ID!]!) {
    repos: nodes(ids: $node_ids) {
      ...repo_fragment
    }
    rateLimit {
      cost
      nodeCount
      remaining
      resetAt
    }
  }
  #{Github::GraphQL::Repository::FRAGMENT}
  graphql

  def self.fetch(*, node_ids : Array(String))
    body = {
      query:     QUERY,
      variables: {
        node_ids: node_ids,
      },
    }.to_json
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    response = HTTP::Client.post(url, headers, body)
    Response.from_json(response.body).data
  end
end
