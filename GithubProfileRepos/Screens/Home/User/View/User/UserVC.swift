//
//  UserVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import UIKit

final class UserVC: UIViewController {
  fileprivate let networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
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
    print("\(self) didLoad")
  }
}
