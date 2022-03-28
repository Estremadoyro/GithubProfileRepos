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

  enum CodingKeys: String, CodingKey {
    case owner, name
    case fullName = "full_name"
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
