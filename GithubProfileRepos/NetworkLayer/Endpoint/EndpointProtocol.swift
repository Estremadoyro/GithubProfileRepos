//
//  EndpointType.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

// Everything necessary to configure an Endpoint
protocol EndpointProtocol {
  // Endpoint structure
  var baseURL: URL { get }
  var path: String { get }

  // HTTP Protocols
  var httpMethod: HTTPMethod { get }
  var httpTask: HTTPTask { get }
  var httpHeaders: HTTPHeaders? { get }
}
