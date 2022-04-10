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
  @IBOutlet private weak var userStars: UILabel!

  // Observable passed from ContainerVC
  fileprivate weak var reposObservable: PublishSubject<[Repo]>?

  // User View Model
  fileprivate lazy var userViewModel = UserViewModel()

  // Own observables
  fileprivate lazy var userFollowersObservable: PublishSubject<Followers> = userViewModel.userFollowersObservable
  fileprivate lazy var userFollowingObservable: PublishSubject<Following> = userViewModel.userFollowingObservable

  fileprivate let disposeBag = DisposeBag()

  init(reposObservable: PublishSubject<[Repo]>) {
    self.reposObservable = reposObservable
    super.init(nibName: Nibs.userView, bundle: Bundle.main)
  }

  deinit {
    print("\(self) deinited")
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UserVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    userUsername.text = "Loading..."
    userFollowers.text = "Loading..."
    userFollowing.text = "Loading..."
    userStars.text = "-"
    configureBindings()
  }
}

private extension UserVC {
  func configureBindings() {
    guard let reposObservable = reposObservable else { return }
    bindUsername(reposObservable: reposObservable)
    bindFollowsAndFollowers(reposObservable: reposObservable)
    bindUserStars(reposObservable: reposObservable)
  }
}

private extension UserVC {
  func bindUsername(reposObservable: PublishSubject<[Repo]>) {
    // For the user, we only need the Owner's name from the first Repo.
    // Hence why Repo has the Owner in its structure, this way we save ourselves from making an API call to @user, as Repos' endpoint already provides it.
    reposObservable
      .map { repos in
        let userUsername: String? = repos.first?.owner.name.lowercased()
        return "@\(userUsername ?? "")"
      }
      .bind(to: userUsername.rx.text)
      .disposed(by: disposeBag)
  }
}

private extension UserVC {
  func bindFollowsAndFollowers(reposObservable: PublishSubject<[Repo]>) {
    reposObservable
      .map { repos -> User? in
        repos.first?.owner
      }
      .subscribe(onNext: { [weak self] user in
        guard let user = user else { return }
        self?.userViewModel.updateFollowersSequence(username: user.name)
        self?.userViewModel.updateFollowingSequence(username: user.name)
      })
      .disposed(by: disposeBag)

    bindUserFollowers(reposObservable: reposObservable)
    bindUserFollowing(reposObservable: reposObservable)
  }

  func bindUserFollowers(reposObservable: PublishSubject<[Repo]>) {
    userFollowersObservable
      .map { "\($0.count) followers" }
      .bind(to: userFollowers.rx.text)
      .disposed(by: disposeBag)
  }

  func bindUserFollowing(reposObservable: PublishSubject<[Repo]>) {
    userFollowingObservable
      .map { "\($0.count) following" }
      .bind(to: userFollowing.rx.text)
      .disposed(by: disposeBag)
  }
}

extension UserVC {
  func bindUserStars(reposObservable: PublishSubject<[Repo]>) {
    reposObservable
      .map { repos -> String in
        let stars = Utils.getUserAccumulatedStars(repos: repos)
        return String(stars)
      }
      .bind(to: userStars.rx.text)
      .disposed(by: disposeBag)
  }
}
