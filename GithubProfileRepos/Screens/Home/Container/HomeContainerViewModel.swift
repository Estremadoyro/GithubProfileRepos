//
//  HomeContainerViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 6/04/22.
//

import RxSwift
import UIKit

final class HomeContainerViewModel {
  fileprivate weak var homeView: HomeContainerVC?
  fileprivate let networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }
}

extension HomeContainerViewModel {
  func getReposFromUsername(username: String) -> Observable<[Repo]> {
    return Observable.create { [weak self] observer in
      self?.networkManager.getReposByUsername(username: username, mocking: true, completion: { repos, error in
        if let error = error { observer.onError(error) }
        if let repos = repos { observer.onNext(repos) }
        observer.onCompleted()
      })
      return Disposables.create()
    }
  }
}
