//
//  HomeContainerViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 6/04/22.
//

import RxRelay
import RxSwift
import UIKit

final class HomeContainerViewModel {
  fileprivate let networkManager: NetworkManager
  var currentUser = User(name: "estremadoyro")

  // Observables
  lazy var currentUserObservable = PublishRelay<User>()
  lazy var userReposObservable = PublishSubject<[Repo]>()

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension HomeContainerViewModel {
  /// # Need to be both `**Observable & Observer**
  func updateUserReposSequence() {
    networkManager.getReposByUsername(username: currentUser.name, mocking: true) { [weak self] repos, error in
      if let error = error { self?.userReposObservable.onError(error) }
      if let repos = repos { self?.userReposObservable.onNext(repos) }
      print("userReposObservable DID EMIT event")
    }
  }
}
