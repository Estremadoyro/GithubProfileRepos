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

  weak var reposTableViewModel: ReposTableViewModel?
  weak var disposeBag: DisposeBag?

  lazy var currentRepoCellObservable = PublishSubject<Repo>()

  var repo: Repo? {
    didSet {
      guard let repo = repo else { return }
      configureBindings(repo: repo)
      currentRepoCellObservable.onNext(repo)
    }
  }
}

private extension RepoCell {
  func configureBindings(repo: Repo) {
    bindRepoLanguages(repo: repo)
    bindRepoInfo(repo: repo)
  }
}

private extension RepoCell {
  func bindRepoLanguages(repo: Repo) {
    reposTableViewModel?.repoLanguagesObservable
      .map { [weak self] languages in
        let mostUsedLanguage = Utils.getMostUsedLanguage(languages: languages)
        DispatchQueue.main.async {
          self?.setLanguageColor(language: mostUsedLanguage)
        }
        return mostUsedLanguage.key
      }
      .bind(to: repoLanguages.rx.text)
      .disposed(by: disposeBag ?? DisposeBag())
  }

  // TODO: Can this be improved? Too much boiler
  func bindRepoInfo(repo: Repo) {
    guard let disposeBag = disposeBag else { return }

    currentRepoCellObservable
      .map { $0.name }
      .bind(to: repoName.rx.text)
      .disposed(by: disposeBag)

    currentRepoCellObservable
      .map { $0.description }
      .bind(to: repoDescription.rx.text)
      .disposed(by: disposeBag)

    currentRepoCellObservable
      .map { [weak self] repo in
        self?.setStars(starsCount: repo.stars)
        return String(repo.stars)
      }
      .bind(to: repoStarCount.rx.text)
      .disposed(by: disposeBag)
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
  }
}
