//
//  Router.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

/// # MAKES THE REQUEST ITSELF
// Any Endpoint that conforms EndpointProtocol can be used to make and HTTPRequest
class Router<Endpoint: EndpointProtocol>: RouterProtocol {
  private var task: URLSessionTask?

  func request(_ route: Endpoint, completion: @escaping RouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try buildRequest(from: route)
      print("API ENDPOINT: \(request.url ?? URL(string: "https://www.google.com")!)")
      task = session.dataTask(with: request, completionHandler: { data, response, error in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error)
    }
    task?.resume()
    session.finishTasksAndInvalidate()
  }

  func cancel() {
    task?.cancel()
  }
}

private extension Router {
  func buildRequest(from route: Endpoint) throws -> URLRequest {
    let endpoint = route.baseURL.appendingPathComponent(route.path)
    var request = URLRequest(url: endpoint, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
    request.httpMethod = HTTPMethod.get.rawValue

    do {
      switch route.httpTask {
        case .request:
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestWithParameters(let urlParameters, let bodyParameters):
          try configureParameters(urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
      }
    } catch {
      throw error
    }
    return request
  }
}

private extension Router {
  func configureParameters(urlParameters: Parameters?, bodyParameters: Parameters?, request: inout URLRequest) throws {
    do {
      if let urlParameters = urlParameters {
        try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
      }
      if let bodyParameters = bodyParameters {
        try JSONBodyParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
      }
    } catch {
      throw error
    }
  }
}
