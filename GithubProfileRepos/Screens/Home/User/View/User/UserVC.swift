//
//  UserVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import RxCocoa
import RxSwift
import UIKit

final class UserVC: UIViewController {
  @IBOutlet private weak var userUsername: UILabel!
  @IBOutlet private weak var userFollowing: UILabel!
  @IBOutlet private weak var userFollowers: UILabel!

  // Observable passed from ContainerVC
  fileprivate weak var reposObservable: Observable<[Repo]>?

  // User View Model
  fileprivate lazy var userViewModel = UserViewModel(networkManager: networkManager)

  // Own observables
  fileprivate var userFollowersObservable: Observable<Followers>?
  fileprivate var userFollowingsObservable: Observable<Following>?
  fileprivate weak var disposeBag: DisposeBag?

  fileprivate let networkManager: NetworkManager

  init(networkManager: NetworkManager, reposObservable: Observable<[Repo]>, disposeBag: DisposeBag) {
    self.networkManager = networkManager
    self.reposObservable = reposObservable
    self.disposeBag = disposeBag
    super.init(nibName: Nibs.userView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UserVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    userUsername.text = ""
    configureBindings()
  }
}

private extension UserVC {
  func configureBindings() {
    bindUserFollowers()
    bindUserFollowing()
    guard let reposObservable = reposObservable else { return }
    bindUsername(reposObservable: reposObservable)
  }
}

private extension UserVC {
  func bindUsername(reposObservable: Observable<[Repo]>) {
    // For the user, we only need the Owner's name from the first Repo.
    // Hence why Repo has the Owner in its structure, this way we save ourselves from making an API call to @user, as Repos' endpoint already provides it.
    reposObservable
      .map { repos in
        let userUsername: String? = repos.first?.owner.name.lowercased()
        return "@\(userUsername ?? "")"
      }
      .bind(to: userUsername.rx.text)
      .disposed(by: disposeBag ?? DisposeBag())
  }
}

// TODO
private extension UserVC {
  func bindUserFollowers() {}

  func bindUserFollowing() {}
}
