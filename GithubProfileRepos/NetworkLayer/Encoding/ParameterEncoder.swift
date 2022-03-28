//
//  ParameterEncoding.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParametersError: String, Error {
  case parametersNil = "Parameters were nil"
  case encodingFailded = "Parameters encoding failed"
  case missingURL = "URL is nil"
}
