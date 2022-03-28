//
//  URLParameterEncoder.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    guard let url = urlRequest.url else { throw ParametersError.missingURL }
    guard !parameters.isEmpty else { throw ParametersError.parametersNil }
    var urlBuilder = URLComponents(url: url, resolvingAgainstBaseURL: false)
    urlBuilder?.queryItems = [URLQueryItem]()
    for (key, value) in parameters {
      if let valueToString = value as? String {
        let valueEncoded = valueToString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let queryItem = URLQueryItem(name: key, value: valueEncoded)
        urlBuilder?.queryItems?.append(queryItem)
      } else {
        throw ParametersError.encodingFailded
      }
    }
    // Update the URLRequest url
    urlRequest.url = urlBuilder?.url
    print("URL with encoded characters: \(String(describing: urlBuilder?.url))")

    // Add content type header value
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
  }
}
