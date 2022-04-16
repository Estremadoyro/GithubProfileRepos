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
    reposObservable: reposFromUserNameObservable,
    currentUserObservable: currentUserObservable
  )
  fileprivate lazy var reposTableVC = ReposTableVC(
    reposObservable: reposFromUserNameObservable
  )

  // Container View Model
  fileprivate lazy var homeContainerViewModel = HomeContainerViewModel(networkManager: self.networkManager)

  // Shared among User/Repos observables
  fileprivate lazy var currentUserObservable: PublishRelay<UserProfile> = homeContainerViewModel.currentUserObservable
  fileprivate lazy var reposFromUserNameObservable: PublishSubject<[Repo]> = homeContainerViewModel.userReposObservable

  fileprivate lazy var disposeBag = DisposeBag()

  // Network manager
  fileprivate var networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }

  deinit {
    print("\(self) deinited")
    reposFromUserNameObservable.dispose()
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
    homeContainerViewModel.updateUserSequence(username: "estremadoyro")
//    currentUserObservable.accept(UserProfile(name: "pieronarciso"))
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
      .asObservable()
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] user in
        print("USER UPDATED TO: \(user.name)")
        self?.homeContainerViewModel.updateUserReposSequence(username: user.name)
      })
      .disposed(by: disposeBag)
  }
}

private extension HomeContainerVC {
  func buildScreen() {
    print("BUILDING SCREEN")
    // Add search bar
    print("ADDING SEARCH BAR")
    let homeSearchBarVC = HomeSearchBar(currentUserRelay: currentUserObservable)
    homeSearchBarVC.homeSearchBarViewModel.networkManager = networkManager
    navigationItem.searchController = homeSearchBarVC

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
