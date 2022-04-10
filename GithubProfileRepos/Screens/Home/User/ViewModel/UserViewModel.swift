//
//  UserViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 7/04/22.
//

import RxSwift

final class UserViewModel {
  fileprivate lazy var networkManager = NetworkManager()
  lazy var userFollowersObservable = PublishSubject<Followers>()
  lazy var userFollowingObservable = PublishSubject<Following>()
}

extension UserViewModel {
  func updateFollowersSequence(username: String) {
    networkManager.getUserFollowers(username: username, mocking: true) { [weak self] followers, error in
      if let error = error { self?.userFollowersObservable.onError(error) }
      if let followers = followers { self?.userFollowersObservable.onNext(followers) }
    }
  }

  func updateFollowingSequence(username: String) {
    networkManager.getUserFollowing(username: username, mocking: true) { [weak self] followers, error in
      if let error = error { self?.userFollowingObservable.onError(error) }
      if let followers = followers { self?.userFollowingObservable.onNext(followers) }
    }
  }
}
