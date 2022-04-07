//
//  UserViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 7/04/22.
//

import RxSwift

final class UserViewModel {
  fileprivate var networkManager: NetworkManager
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

// I think these won't be Observables if observing the userUsername UILabel for changes
extension UserViewModel {
  func getUserFollowers(username: String) -> Observable<Followers> {
    return Observable.create { [weak self] observer in
      self?.networkManager.getUserFollowers(username: username, mocking: true) { followers, error in
        if let followers = followers { observer.onNext(followers) }
        if let error = error { observer.onError(error) }
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }

  func getUserFollowing(username: String) -> Observable<Following> {
    return Observable.create { [weak self] observer in
      self?.networkManager.getUserFollowing(username: username, mocking: true) { following, error in
        if let following = following { observer.onNext(following) }
        if let error = error { observer.onError(error) }
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
