require "./connection"
require "./ref"

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
    tags: Github::GraphQL::Connection(Github::GraphQL::Ref)
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
    tags: refs(refPrefix: "refs/tags/", first: 100) {
      ...ref
    }
  }

  #{Github::GraphQL::Ref::FRAGMENT}
  graphql
end
