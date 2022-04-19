//
//  NetworkRequestsProtocol.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 1/04/22.
//

import Foundation

protocol NetworkCompletionsProtocol {
  typealias GithubUserCompletion = (_ user: UserProfile?, _ error: Error?) -> ()
  typealias GithubUserReposCompletion = (_ repos: [Repo]?, _ error: Error?) -> ()
  typealias GithubUserFollowersCompletion = (_ followers: Followers?, _ error: Error?) -> ()
  typealias GithubUserFollowingCompletion = (_ following: Following?, _ error: Error?) -> ()
  typealias GithubRepoLanguagesCompletion = (_ languages: RepoLanguages?, _ error: Error?) -> ()
}

protocol NetworkRequestsProtocol: NetworkCompletionsProtocol {
  func getUser(username: String, mocking: Bool, completion: @escaping GithubUserCompletion)
  func getReposByUsername(username: String, mocking: Bool, completion: @escaping GithubUserReposCompletion)
  func getUserFollowers(username: String, mocking: Bool, completion: @escaping GithubUserFollowersCompletion)
  func getUserFollowing(username: String, mocking: Bool, completion: @escaping GithubUserFollowingCompletion)
  mutating func getLanguagesByRepo(repo: Repo, mocking: Bool, completion: @escaping GithubRepoLanguagesCompletion)
}
