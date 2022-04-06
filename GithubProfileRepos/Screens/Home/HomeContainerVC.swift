//
//  HomeContainerVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import UIKit

/// # `Container ViewController` which has the following ViewControllers as children:
/// **UserVC**
/// **ReposTableVC**
final class HomeContainerVC: UIViewController {
  fileprivate lazy var userVC = UserVC(networkManager: networkManager)
  fileprivate lazy var reposTableVC = ReposTableVC(networkManager: networkManager)
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
    configureContainerView()
    buildScreen()
  }
}

private extension HomeContainerVC {
  func configureContainerView() {
//    view.backgroundColor = UIColor.systemIndigo
    view.backgroundColor = UIColor.systemBackground
    navigationItem.title = "Repos"
  }
}

private extension HomeContainerVC {
  func buildScreen() {
    // Add child VCs
    addChildVC(userVC)
    addChildVC(reposTableVC)
    // Configure child VCs
    configureUserVC()
    configureReposTableVC()
  }
}

private extension HomeContainerVC {
  func configureUserVC() {
    userVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      userVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//      userVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
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
