//
//  RouterStructure.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

public typealias RouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol RouterProtocol {
  // Necessary for the request to take a generic route
  associatedtype Endpoint = EndpointProtocol
  func request(_ route: Endpoint, completion: @escaping RouterCompletion)
  func cancel()
}
