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
  @IBOutlet private weak var repoDescription: UILabel!
  @IBOutlet private weak var repoLanguages: UILabel!
  @IBOutlet private weak var repoLanguageColor: UIImageView!
  @IBOutlet private weak var repoStar: UIImageView!
  @IBOutlet private weak var repoStarCount: UILabel!

  weak var homeViewModel: HomeViewModel?
  weak var disposeBag: DisposeBag?

  var repo: Repo? {
    didSet {
      guard let repo = repo else { return }
      repoName.text = repo.name
      repoDescription.text = repo.description
      bindLanguagesFromRepo(repo: repo)
      setStars(starsCount: repo.stars)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

private extension RepoCell {
  func bindLanguagesFromRepo(repo: Repo) {
    homeViewModel?.getLanguagesFromRepo(repo: repo)
      .map { [weak self] languages in
        guard let strongSelf = self else { return "No language" }
        let mostUsedLanguage = strongSelf.getMostUsedLanguage(languages: languages)
        DispatchQueue.main.async {
          self?.setLanguageColor(language: mostUsedLanguage)
        }
        return mostUsedLanguage.key
      }
      .bind(to: repoLanguages.rx.text)
      .disposed(by: disposeBag ?? DisposeBag())
  }
}

private extension RepoCell {
  func getMostUsedLanguage(languages: RepoLanguage) -> ColorByLanguage.Element {
    return Utils.getMostUsedLanguage(languages: languages)
  }

  func setLanguageColor(language: ColorByLanguage.Element) {
    repoLanguageColor.tintColor = language.value
  }

  func setStars(starsCount: Int) {
    if starsCount > 0 {
      repoStar.image = UIImage(systemName: "star.fill")
      repoStar.tintColor = UIColor.systemOrange
    } else {
      repoStar.image = UIImage(systemName: "star")
      repoStar.tintColor = UIColor.systemGray
    }

    repoStarCount.text = "\(starsCount)"
  }
}
