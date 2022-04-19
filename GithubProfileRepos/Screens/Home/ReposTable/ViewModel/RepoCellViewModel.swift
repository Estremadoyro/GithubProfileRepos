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
  var currentRepoLanguagesObservable = PublishSubject<RepoLanguages>()

  deinit { print("\(self) deinited") }
}

extension RepoCellViewModel {
  func updateCurrentRepoSequence(repo: Repo) {
    currentRepoObservable.onNext(repo)
  }

  func updateRepoLanguagesSequence(repo: Repo) {
    print("updateRepo: \(repo.name)")
    networkManager?.getLanguagesByRepo(repo: repo, mocking: true, completion: { [weak self] languages, error in
      if let error = error { self?.currentRepoLanguagesObservable.onError(error) }
      if let languages = languages { self?.currentRepoLanguagesObservable.onNext(languages) }
    })
  }
}
