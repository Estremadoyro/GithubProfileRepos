//
//  UserRepos.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

struct Repo: Decodable {
  let owner: Owner
  let name: String
  let fullName: String
  let description: String?
  let stars: Int

  enum CodingKeys: String, CodingKey {
    case owner, name, description
    case fullName = "full_name"
    case stars = "stargazers_count"
  }
}

struct Owner: Decodable {
  let name: String
  let url: String

  enum CodingKeys: String, CodingKey {
    case url = "html_url"
    case name = "login"
  }
}

public typealias RepoLanguage = [String: Int]
