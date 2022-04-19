//
//  UserViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 7/04/22.
//

import RxSwift

final class UserViewModel {
  var networkManager: NetworkManager?
  lazy var userFollowersObservable = PublishSubject<Followers>()
  lazy var userFollowingObservable = PublishSubject<Following>()
  lazy var userProfilePictureObservable = PublishSubject<UIImage>()
}

extension UserViewModel {
  // These 2 are not used anymore, as UserProfile already comes with the # of followers and following
  func updateFollowersSequence(username: String) {
    networkManager?.getUserFollowers(username: username, mocking: false) { [weak self] followers, error in
      if let error = error { self?.userFollowersObservable.onError(error) }
      if let followers = followers { self?.userFollowersObservable.onNext(followers) }
    }
  }

  func updateFollowingSequence(username: String) {
    networkManager?.getUserFollowing(username: username, mocking: false) { [weak self] followers, error in
      if let error = error { self?.userFollowingObservable.onError(error) }
      if let followers = followers { self?.userFollowingObservable.onNext(followers) }
    }
  }

  func updateProfilePictureSequence(source: String?) {
    Utils.getImageFromSource(source: source) { [weak self] profilePicture, error in
      if let error = error { self?.userProfilePictureObservable.onError(error) }
      self?.userProfilePictureObservable.onNext(profilePicture)
    }
  }
}
