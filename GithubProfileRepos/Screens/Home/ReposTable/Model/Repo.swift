//
//  UserRepos.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

struct Repo: Decodable {
  let owner: User
  let name: String
  let fullName: String
  let description: String?
  let stars: Int

  enum CodingKeys: String, CodingKey {
    case owner, name, description
    case fullName = "full_name"
    case stars = "stargazers_count"
  }

  // Can be used for generating a Unique ID based on the Repo properties
//  struct ID {
//    let id = UUID()
//  }
}

extension Repo: Hashable {
  static func == (lhs: Repo, rhs: Repo) -> Bool {
    return
      lhs.owner == rhs.owner &&
      lhs.name == rhs.name &&
      lhs.fullName == rhs.fullName &&
      lhs.description == rhs.description &&
      lhs.stars == rhs.stars
  }
}

// Language name + # lines
public typealias RepoLanguages = [String: Int]
