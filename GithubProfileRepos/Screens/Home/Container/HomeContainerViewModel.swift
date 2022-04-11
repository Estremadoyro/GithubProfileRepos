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

  // Observables
  lazy var currentUserObservable = PublishRelay<UserProfile>()
  lazy var userReposObservable = PublishSubject<[Repo]>()

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension HomeContainerViewModel {
  /// # Need to be both `**Observable & Observer**
  func updateUserReposSequence(username: String) {
    networkManager.getReposByUsername(username: username, mocking: true) { [weak self] repos, error in
      if let error = error { self?.userReposObservable.onError(error) }
      if let repos = repos {
        self?.userReposObservable.onNext(repos)
        print("REPOS OBTAINED: \(repos.count)")
      }
      print("userReposObservable DID EMIT event")
    }
  }

  // Currently not necessary, unless wanting to access the Bio
  func updateUserSequence(username: String) {
    networkManager.getUser(username: username, mocking: true) { [weak self] user, error in
      if error != nil { self?.currentUserObservable.accept(UserProfile(name: "Error")) }
      if let user = user {
        self?.currentUserObservable.accept(user)
        print("New user emited: \(user.name)")
      }
    }
  }
}
