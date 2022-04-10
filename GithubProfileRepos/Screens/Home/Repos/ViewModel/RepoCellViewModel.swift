//
//  RepoCellViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 10/04/22.
//

import Foundation
import RxSwift

enum RepoError: Error {
  case noRepo
}

final class RepoCellViewModel {
//  lazy var networkManager = NetworkManager()
  var networkManager: NetworkManager?
  deinit { print("\(self) deinited") }
}

extension RepoCellViewModel {
  func currentRepoObservable(repo: Repo?) -> Observable<Repo> {
    Observable<Repo>.create { observer in
      if let currentRepo = repo {
        observer.onNext(currentRepo)
        observer.onCompleted()
      } else {
        observer.onError(RepoError.noRepo)
      }
      return Disposables.create()
    }
  }

  func currentRepoLanguagesObservable(repo: Repo?) -> Observable<RepoLanguage> {
    return Observable.create { [weak self] observer in
      if let repo = repo {
        self?.networkManager?.getLanguagesByRepo(repo: repo, mocking: false) { languages, error in
          if let languages = languages { observer.onNext(languages) }
          if let error = error { observer.onError(error) }
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}
