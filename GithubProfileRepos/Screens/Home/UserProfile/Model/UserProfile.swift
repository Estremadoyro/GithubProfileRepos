//
//  UserProfile.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 10/04/22.
//

import Foundation

struct UserProfile: Decodable, Equatable {
  let name: String
  let profilePicture: String
  let bio: String?
  let reposCount: Int
  let followers: Int
  let following: Int

  enum CodingKeys: String, CodingKey {
    case bio, followers, following
    case name = "login"
    case profilePicture = "avatar_url"
    case reposCount = "public_repos"
  }

  init(name: String) {
    self.name = name
    self.profilePicture = ""
    self.bio = ""
    self.reposCount = 0
    self.followers = 0 
    self.following = 0
  }
}
