//
//  GithubEndpoint.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

/// # CREATES THE `ENDPOINT` FULL PATH TO CREATE AN HTTPRequest WITH
/// https://api.github.com/users/estremadoyro/repos

/// Should have 2 Endpoint modules actually, one for users/ and other for repos/

// All the request methods for this endpoint
enum GithubUsersEndpoint {
  case reposByUsername(username: String)
  case languagesByRepo(repo: Repo)
  case userFollowers(username: String)
  case userFollowing(username: String)
}

// Set the base URL
extension GithubUsersEndpoint {
  var environmentBaseURL: String {
    switch NetworkManager.environment {
      case .production: return "https://api.github.com/"
      case .develop: return "https://api.github.com/"
    }
  }
}

extension GithubUsersEndpoint: EndpointProtocol {
  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("Base URL could not be encoded") }
    return url
  }

  var path: String {
    switch self {
      case .reposByUsername(let username):
        return "users/\(username)/repos"
      case .languagesByRepo(let repo):
        return "repos/\(repo.owner.name)/\(repo.name)/languages"
      case .userFollowers(let username):
        return "users/\(username)/followers"
      case .userFollowing(let username):
        return "users/\(username)/following"
    }
  }

  var httpMethod: HTTPMethod {
    return HTTPMethod.get
  }

  var httpTask: HTTPTask {
    switch self {
      case .languagesByRepo, .userFollowers, .userFollowing:
        return .request
      case .reposByUsername:
        return .requestWithParameters(
          urlParameters:
          ["sort": "pushed", "direction": "desc"],
          bodyParameters: nil)
    }
  }

  var httpHeaders: HTTPHeaders? {
    return ["authorization": "token \(Keys.githubApiKey)"]
  }
}
