//
//  HomeView.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import UIKit

class HomeView: UIViewController {
  var networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: Nibs.homeView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeView {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemIndigo
    navigationItem.title = "Repos"
    loadReposFromUsername(username: "estremadoyro")
  }
}

extension HomeView {
  private func loadReposFromUsername(username: String) {
    networkManager.getReposByUsername(username: username) { repos, error in
      if let repos = repos {
        print("Repos from \(username): \(repos.map { $0.name })")
      } else {
        print("Error @ VC: \(error ?? "")")
      }
    }
  }
}
