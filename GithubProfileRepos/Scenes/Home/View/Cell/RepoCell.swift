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
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func displayLanguagesFromRepo(repo: Repo) {
    homeViewModel?.getLanguagesFromRepo(repo: repo)
      .subscribe { [weak self] languages in
        DispatchQueue.main.async {
          self?.repoLanguages.text = self?.parseLanguages(languages: languages)
          print("Language: \(languages.map { $0.key })")
        }
      } onError: { error in
        print("Error @ VC: \(error)")
      }.disposed(by: disposeBag ?? DisposeBag())
  }
}

private extension RepoCell {
  func parseLanguages(languages: RepoLanguages) -> String {
    return languages.map { $0.key }.joined(separator: " | ")
  }
}
