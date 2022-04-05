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
    print("VM getReposFromUsername")
    return Observable.create { observer in
      print("VM Observer: \(observer)")
      self.networkManager.getReposByUsername(username: username, mocking: true, completion: { repos, error in
        if let error = error {
          observer.onError(error)
        }
        if let repos = repos {
          print("VM repos exists")
          observer.onNext(repos)
        }
        observer.onCompleted()
        print("VM Rx repos sequence completed")
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
        print("Rx languages sequence languages")
//        print("LANGUAGES: \(String(describing: languages))")
      })
      return Disposables.create()
    }
  }
}
