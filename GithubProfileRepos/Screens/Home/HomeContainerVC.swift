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
  fileprivate var userVC: UserVC?
  fileprivate var reposTableVC: ReposTableVC?
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
  }
}

private extension HomeContainerVC {
  func initializeHomeVCs() {
    userVC = UserVC(networkManager: networkManager)
//    userVC = UserVC(nibName: Nibs.userView, bundle: Bundle.main)
//    reposTableVC = ReposTableVC(nibName: Nibs.reposTableView, bundle: Bundle.main)
  }
}

private extension HomeContainerVC {
  func buildScreen() {
    guard let userVC = userVC, let reposTableVC = reposTableVC else { return }
    addChild(userVC)
    view.addSubview(userVC.view)
    userVC.didMove(toParent: self)
  }
}
