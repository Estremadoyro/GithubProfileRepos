//
//  User.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 6/04/22.
//

import Foundation

struct User: Decodable {
  let name: String

  enum CodingKeys: String, CodingKey {
    case name = "login"
  }
}

typealias Followers = [User]
typealias Following = [User]
