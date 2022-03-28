//
//  HTTPTask.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

public enum HTTPTask {
  case request
  case requestWithParameters(urlParameters: Parameters?, bodyParameters: Parameters?)
}
