//
//  GithubEndpoint.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

/// # CREATES THE `ENDPOINT` FULL PATH TO CREATE AN HTTPRequest WITH
/// https://api.github.com/users/estremadoyro/repos

// All the request methods for this endpoint
public enum GithubUsersEndpoint {
  case reposByUsername(username: String)
}

// Set the base URL
extension GithubUsersEndpoint {
  var environmentBaseURL: String {
    switch NetworkManager.environment {
      case .production: return "https://api.github.com/users/"
      case .develop: return "https://api.github.com/users/"
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
        return "\(username)/repos"
    }
  }

  var httpMethod: HTTPMethod {
    return HTTPMethod.get
  }

  var httpTask: HTTPTask {
    switch self {
      case .reposByUsername:
        return .request
    }
  }

  var httpHeaders: HTTPHeaders? {
    return nil
  }
}
