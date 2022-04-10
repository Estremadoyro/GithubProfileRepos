//
//  HomeContainerVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import RxRelay
import RxSwift
import UIKit

/// # `Container ViewController` which has the following ViewControllers as children:
/// **UserVC**
/// **ReposTableVC**
final class HomeContainerVC: UIViewController {
  // ViewControllers
  fileprivate lazy var userVC = UserVC(
    reposObservable: reposFromUserNameObservable
  )
  fileprivate lazy var reposTableVC = ReposTableVC(
    reposObservable: reposFromUserNameObservable
  )

  // Container View Model
  fileprivate lazy var homeContainerViewModel = HomeContainerViewModel(networkManager: self.networkManager)

  // Shared among User/Repos observables
  fileprivate lazy var currentUserObservable: PublishRelay<User> = homeContainerViewModel.currentUserObservable
  fileprivate lazy var reposFromUserNameObservable: PublishSubject<[Repo]> = homeContainerViewModel.userReposObservable

  fileprivate lazy var disposeBag = DisposeBag()

  // Network manager
  fileprivate var networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeContainerVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBindings()
    configureContainerView()
    buildScreen()

    // First User event
    currentUserObservable.accept(User(name: "estremadoyro"))
  }
}

private extension HomeContainerVC {
  func configureContainerView() {
    view.backgroundColor = UIColor.systemBackground
    navigationItem.title = "Repos"
  }
}

private extension HomeContainerVC {
  func configureBindings() {
    currentUserObservable
      .subscribe(onNext: { [weak self] _ in
        self?.homeContainerViewModel.updateUserReposSequence()
      })
      .disposed(by: disposeBag)
  }
}

private extension HomeContainerVC {
  func buildScreen() {
    print("BUILDING SCREEN")
    // Add child VCs (Also instantiating them)
    addChildVC(userVC)
    addChildVC(reposTableVC)

    // Configure child VCs
    configureUserVC()
    configureReposTableVC()
    print("BUILDING SCREEN ENDED")
  }
}

private extension HomeContainerVC {
  func configureUserVC() {
    userVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      userVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      userVC.view.heightAnchor.constraint(lessThanOrEqualToConstant: 120),
      userVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      userVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }

  func configureReposTableVC() {
    reposTableVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      reposTableVC.view.topAnchor.constraint(equalTo: userVC.view.bottomAnchor, constant: 5),
      reposTableVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      reposTableVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      reposTableVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}
