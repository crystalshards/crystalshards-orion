require "./connection"
require "./release"

class Github::GraphQL::Repository
  JSON.mapping(
    url: String,
    updated_at: {type: String?, key: "updatedAt"},
    homepage_url: {type: String?, key: "homepageUrl"},
    watchers: Github::GraphQL::Connection(Nil),
    forks: Github::GraphQL::Connection(Nil),
    stargazers: Github::GraphQL::Connection(Nil),
    pull_requests: {type: Github::GraphQL::Connection(Nil), key: "pullRequests"},
    issues: {type: Github::GraphQL::Connection(Nil), key: "issues"},
    releases: Github::GraphQL::Connection(Github::GraphQL::Release)
  )
  FRAGMENT = <<-graphql
  fragment repo_fragment on Repository {
    url
    homepageUrl
    updatedAt
    watchers {
      totalCount
    }
    forks {
      totalCount
    }
    stargazers {
      totalCount
    }
    pullRequests {
      totalCount
    }
    issues {
      totalCount
    }
    releases(first: 10, orderBy:{ field: CREATED_AT, direction: DESC }) {
      nodes {
        ...release
      }
    }
  }

  #{Github::GraphQL::Release::FRAGMENT}
  graphql
end
