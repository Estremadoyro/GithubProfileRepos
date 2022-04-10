//
//  HomeViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 28/03/22.
//

import Foundation
import RxSwift

final class ReposTableViewModel {
  // Observables
  lazy var repoLanguagesObservable = PublishSubject<RepoLanguage>()

  fileprivate lazy var networkManager = NetworkManager()
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

  func updateLanguagesSequence(repo: Repo) {
    networkManager.getLanguagesByRepo(repo: repo, mocking: true) { [weak self] languages, error in
      if let error = error { self?.repoLanguagesObservable.onError(error) }
      if let languages = languages { self?.repoLanguagesObservable.onNext(languages) }
    }
  }
}
