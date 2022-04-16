//
//  SearchUserResultItemViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 14/04/22.
//

import Foundation
import RxSwift

class SearchUserResultItemViewModel {
  let userProfilePictureObservable = PublishSubject<UIImage>()

  func updateProfilePictureSequence(source: String?) {
    Utils.getImageFromSource(source: source) { [weak self] profilePicture, error in
      if let error = error { self?.userProfilePictureObservable.onError(error) }
      self?.userProfilePictureObservable.onNext(profilePicture)
    }
  }
}
