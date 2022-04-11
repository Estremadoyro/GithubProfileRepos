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
  var networkManager: NetworkManager?
  var currentRepoObservable = PublishSubject<Repo>()
  var currentRepoLanguagesObservable = PublishSubject<RepoLanguage>()

  deinit { print("\(self) deinited") }
}

extension RepoCellViewModel {
//  func currentRepoObservable(repo: Repo?) -> Observable<Repo> {
//    Observable<Repo>.create { observer in
//      if let currentRepo = repo {
//        observer.onNext(currentRepo)
//        observer.onCompleted()
//      } else {
//        observer.onError(RepoError.noRepo)
//      }
//      return Disposables.create()
//    }
//  }
//
//  func currentRepoLanguagesObservable(repo: Repo?) -> Observable<RepoLanguage> {
//    return Observable.create { [weak self] observer in
//      if let repo = repo {
//        self?.networkManager?.getLanguagesByRepo(repo: repo, mocking: true) { languages, error in
//          if let languages = languages { observer.onNext(languages) }
//          if let error = error { observer.onError(error) }
//          observer.onCompleted()
//        }
//      }
//      return Disposables.create()
//    }
//  }
}

extension RepoCellViewModel {
  func updateCurrentRepoSequence(repo: Repo) {
    currentRepoObservable.onNext(repo)
  }

  func updateRepoLanguagesSequence(repo: Repo) {
    networkManager?.getLanguagesByRepo(repo: repo, mocking: true, completion: { [weak self] languages, error in
      if let error = error { self?.currentRepoLanguagesObservable.onError(error) }
      if let languages = languages { self?.currentRepoLanguagesObservable.onNext(languages) }
    })
  }
}
