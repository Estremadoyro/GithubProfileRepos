//
//  RepoCell.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import RxSwift
import UIKit

final class RepoCell: UITableViewCell {
  @IBOutlet private weak var repoName: UILabel!
  @IBOutlet private weak var repoLanguages: UILabel!

  weak var homeViewModel: HomeViewModel?
  weak var disposeBag: DisposeBag?

  var repo: Repo? {
    didSet {
      guard let repo = repo else { return }
      repoName.text = repo.name
      displayLanguagesFromRepo(repo: repo)
    }
  }

  func displayLanguagesFromRepo(repo: Repo) {
    homeViewModel?.getLanguagesFromRepo(repo: repo)
      .map { [weak self] in
        self?.parseLanguages(languages: $0)
      }
      .bind(to: repoLanguages.rx.text)
      .disposed(by: disposeBag ?? DisposeBag())
  }
}

private extension RepoCell {
  func parseLanguages(languages: RepoLanguages) -> String {
    return languages.map { $0.key }.joined(separator: " | ")
  }
}
