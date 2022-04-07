//
//  HomeViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 28/03/22.
//

import Foundation
import RxSwift

final class ReposTableViewModel {
  var networkManager: NetworkManager
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension ReposTableViewModel {
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
      })
      return Disposables.create()
    }
  }
}
