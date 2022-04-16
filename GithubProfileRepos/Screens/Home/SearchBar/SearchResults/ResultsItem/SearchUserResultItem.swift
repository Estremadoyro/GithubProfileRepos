//
//  SearchUserResultItem.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 14/04/22.
//

import RxSwift
import UIKit

class SearchUserResultItem: UICollectionViewCell {
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var userUsername: UILabel!

  let searchUserResultItemViewModel = SearchUserResultItemViewModel()

  let disposeBag = DisposeBag()

  var searchResultUser: BehaviorSubject<UserProfile>?

  var resultUser: UserProfile? {
    didSet {
      guard let resultUser = resultUser else { return }
      searchResultUser = BehaviorSubject(value: resultUser)
      configureInitialValues()
      configureViewBindings()
    }
  }
}

private extension SearchUserResultItem {
  func configureInitialValues() {
    userProfileImage.image = nil
    userUsername.text = ""
  }
}

private extension SearchUserResultItem {
  func configureViewBindings() {
    searchResultUser?
      .map { $0.name }
      .bind(to: userUsername.rx.text)
      .disposed(by: disposeBag)

    searchUserResultItemViewModel.userProfilePictureObservable
      .bind(to: userProfileImage.rx.image)
      .disposed(by: disposeBag)

    searchResultUser?
      .map { $0.profilePicture }
      .subscribe(onNext: { [weak self] imageSource in
        self?.searchUserResultItemViewModel.updateProfilePictureSequence(source: imageSource)
      })
      .disposed(by: disposeBag)
  }
}
