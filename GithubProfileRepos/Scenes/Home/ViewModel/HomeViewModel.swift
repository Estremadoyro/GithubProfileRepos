//
//  HomeViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 28/03/22.
//

import Foundation
import RxSwift

class HomeViewModel {
  weak var view: HomeView?
  var networkManager: NetworkManager
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension HomeViewModel {
  func getReposFromUsername(username: String) -> Observable<[Repo]> {
    return Observable.create { observer in
      self.networkManager.getReposByUsername(username: username, completion: { repos, error in
        if let error = error {
          observer.onError(error)
        }
        if let repos = repos {
          observer.onNext(repos)
        }
        observer.onCompleted()
        print("Rx Sequence completed")
      })
      return Disposables.create()
    }
  }

  func getLanguagesFromRepo(repo: Repo) -> Observable<RepoLanguages> {
    return Observable.create { observer in
      self.networkManager.getLanguagesByRepo(repo: repo, completion: { languages, error in
        if let error = error {
          observer.onError(error)
          print("Error: \(error)")
        }
        if let languages = languages {
          observer.onNext(languages)
        }
        observer.onCompleted()
        print("Rx Sequence languages")
        print("LANGUAGES: \(String(describing: languages))")
      })
      return Disposables.create()
    }
  }
}
