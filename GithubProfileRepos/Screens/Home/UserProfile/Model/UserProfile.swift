//
//  UserProfile.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 10/04/22.
//

import Foundation

struct UserProfile: Decodable {
  let name: String
  let profilePicture: String
  let bio: String
  let reposCount: Int

  enum CodingKeys: String, CodingKey {
    case bio
    case name = "login"
    case profilePicture = "avatar_url"
    case reposCount = "public_repos"
  }

  init(name: String) {
    self.name = name
    self.profilePicture = ""
    self.bio = ""
    self.reposCount = 0
  }
}
