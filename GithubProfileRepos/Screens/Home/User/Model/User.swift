//
//  User.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 6/04/22.
//

import Foundation

struct User: Decodable {
  let name: String
  let profilePicture: String

  enum CodingKeys: String, CodingKey {
    case name = "login"
    case profilePicture = "avatar_url"
  }

  init(name: String) {
    self.name = name
    self.profilePicture = ""
  }
}

typealias Followers = [User]
typealias Following = [User]
