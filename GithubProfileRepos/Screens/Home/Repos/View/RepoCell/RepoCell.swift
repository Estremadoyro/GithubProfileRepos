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

  lazy var repoCellViewModel = RepoCellViewModel()
  lazy var disposeBag = DisposeBag()

  // Observables
//  lazy var currentRepoObservable: Observable<Repo> = repoCellViewModel.currentRepoObservable(repo: repo).share()
//  lazy var currentRepoLanguagesObservable: Observable<RepoLanguage> = repoCellViewModel.currentRepoLanguagesObservable(repo: repo).share()

  lazy var currentRepoObservable: PublishSubject<Repo> = repoCellViewModel.currentRepoObservable
  lazy var currentRepoLanguagesObservable: PublishSubject<RepoLanguage> = repoCellViewModel.currentRepoLanguagesObservable

  var repo: Repo? {
    didSet {
      guard let repo = repo else { return }
      configureBindings(repo: repo)
      repoCellViewModel.updateCurrentRepoSequence(repo: repo)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    repoLanguages.text = ""
    repoLanguageColor.isHidden = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

private extension RepoCell {
  func configureBindings(repo: Repo) {
    bindRepoLanguages()
    bindRepoInfo()
  }
}

private extension RepoCell {
  func bindRepoLanguages() {
    // Bind RepoLanguages to currentRepoObservable
    currentRepoObservable
      .subscribe(onNext: { [weak self] repo in
        self?.repoCellViewModel.updateRepoLanguagesSequence(repo: repo)
      })
      .disposed(by: disposeBag)

    currentRepoLanguagesObservable
      .map { [weak self] languages in
        let mostUsedLanguage = Utils.getMostUsedLanguage(languages: languages)
        DispatchQueue.main.async {
          self?.setLanguageColor(language: mostUsedLanguage)
          self?.repoLanguageColor.isHidden = false
        }
        return mostUsedLanguage.key
      }
      .bind(to: repoLanguages.rx.text)
      .disposed(by: disposeBag)
  }

  // TODO: Can this be improved? Too much boiler
  func bindRepoInfo() {
    currentRepoObservable
      .map { $0.name }
      .bind(to: repoName.rx.text)
      .disposed(by: disposeBag)

    currentRepoObservable
      .map { $0.description }
      .bind(to: repoDescription.rx.text)
      .disposed(by: disposeBag)

    currentRepoObservable
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
