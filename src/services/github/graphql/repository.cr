require "./connection"
require "./ref"

class Service::Github::GraphQL::Repository
  JSON.mapping(
    id: String,
    url: String,
    name_with_owner: {type: String, key: "nameWithOwner"},
    description: String?,
    updated_at: {type: Time?, key: "updatedAt"},
    pushed_at: {type: Time?, key: "pushedAt"},
    homepage_url: {type: String?, key: "homepageUrl"},
    watchers: Service::Github::GraphQL::Connection(Nil)?,
    repository_topics: {type: Service::Github::GraphQL::Connection(RepositoryTopic)?, key: "repositoryTopics"},
    parent: Repository?,
    stargazers: Service::Github::GraphQL::Connection(Nil)?,
    pull_requests: {type: Service::Github::GraphQL::Connection(Nil)?, key: "pullRequests"},
    issues: {type: Service::Github::GraphQL::Connection(Nil)?, key: "issues"},
    tags: Service::Github::GraphQL::Connection(Github::GraphQL::Ref)?
  )

  FRAGMENT = <<-graphql
  fragment repo_fragment on Repository {
    id
    url
    description
    homepageUrl
    updatedAt
    pushedAt
    nameWithOwner
    watchers {
      totalCount
    }
    repositoryTopics(first: 100) {
      nodes {
        ...repositoryTopic
      }
    }
    parent {
      id
      url
      nameWithOwner
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
      nodes {
        ...ref
      }
    }
  }

  #{Service::Github::GraphQL::RepositoryTopic::FRAGMENT}
  #{Service::Github::GraphQL::Ref::FRAGMENT}
  graphql
end
