//
//  NetworkRequestsProtocol.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 1/04/22.
//

import Foundation

protocol NetworkCompletionsProtocol {
  typealias GithubUserReposCompletion = (_ repos: [Repo]?, _ error: Error?) -> ()
  typealias GithubRepoLanguagesCompletion = (_ languages: RepoLanguage?, _ error: Error?) -> ()
}

protocol NetworkRequestsProtocol: NetworkCompletionsProtocol {
  func getReposByUsername(username: String, mocking: Bool, completion: @escaping GithubUserReposCompletion)
  func getLanguagesByRepo(repo: Repo, mocking: Bool, completion: @escaping GithubRepoLanguagesCompletion)
}
