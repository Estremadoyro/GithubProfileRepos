//
//  HomeViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 28/03/22.
//

import Foundation
import RxSwift

final class ReposTableViewModel {
  weak var view: ReposTableVC?
  var networkManager: NetworkManager
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension ReposTableViewModel {
  func getReposFromUsername(username: String) -> Observable<[Repo]> {
    return Observable.create { observer in
      self.networkManager.getReposByUsername(username: username, mocking: true, completion: { repos, error in
        if let error = error {
          observer.onError(error)
        }
        if let repos = repos {
          observer.onNext(repos)
        }
        observer.onCompleted()
      })
      return Disposables.create()
    }
  }

  func getLanguagesFromRepo(repo: Repo) -> Observable<RepoLanguage> {
    return Observable.create { observer in
      self.networkManager.getLanguagesByRepo(repo: repo, mocking: true, completion: { languages, error in
        if let error = error {
          observer.onError(error)
          print("Error: \(error)")
        }
        if let languages = languages {
          observer.onNext(languages)
        }
        observer.onCompleted()
//        print("Rx languages sequence languages")
      })
      return Disposables.create()
    }
  }
}
