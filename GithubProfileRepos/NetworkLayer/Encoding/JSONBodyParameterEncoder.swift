//
//  JSONBodyParameterEncoder.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

struct JSONBodyParameterEncoder: ParameterEncoder {
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      urlRequest.httpBody = jsonData

      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    } catch {
      throw ParametersError.encodingFailded
    }
  }
}
