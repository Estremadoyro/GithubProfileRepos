//
//  RepoLanguagesCache.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 17/04/22.
//

import Foundation

final class RepoLanguagesCache {
  fileprivate let cache = CacheManager<Repo, RepoLanguages>()

  func getRepoLanguages(repo: Repo) -> RepoLanguages? {
    return cache[repo]
  }

  func setRepoLanguages(repo: Repo, languages: RepoLanguages) {
    cache.insert(languages, forKey: repo)
  }
}
