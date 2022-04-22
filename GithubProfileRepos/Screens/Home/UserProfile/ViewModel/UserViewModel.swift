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
  func updateProfilePictureSequence(source: String?) {
    Utils.getImageFromSource(source: source) { [weak self] profilePicture, error in
      if let error = error { self?.userProfilePictureObservable.onError(error) }
      self?.userProfilePictureObservable.onNext(profilePicture)
    }
  }
}
