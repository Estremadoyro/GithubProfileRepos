//
//  User.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 6/04/22.
//

import Foundation

struct User: Decodable, Hashable {
  let name: String

  enum CodingKeys: String, CodingKey {
    case name = "login"
  }

  init(name: String) {
    self.name = name
  }
}

typealias Followers = [User]
typealias Following = [User]
