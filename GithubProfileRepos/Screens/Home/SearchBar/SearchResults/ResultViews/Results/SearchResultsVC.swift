//
//  SearchResultsVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 11/04/22.
//

import RxCocoa
import RxSwift
import UIKit

// Must deinit when Searching is not active
final class SearchResultsVC: UIViewController {
  @IBOutlet private weak var searchHelpLabel: UILabel!
  @IBOutlet private weak var searchHelpTopAnchor: NSLayoutConstraint!
  @IBOutlet private weak var searchResultsCollection: UICollectionView!

  let searchResultsViewModel = SearchResultsViewModel()

  weak var currentUserRelay: PublishRelay<UserProfile>?
  weak var resultUsersSubject: PublishSubject<[UserProfile]>?

  let searchingUserSubject: PublishSubject<Bool>

  let disposeBag = DisposeBag()

  init(currentUserRelay: PublishRelay<UserProfile>, resultUsersSubject: PublishSubject<[UserProfile]>, searchingUserSubject: PublishSubject<Bool>) {
    self.currentUserRelay = currentUserRelay
    self.resultUsersSubject = resultUsersSubject
    self.searchingUserSubject = searchingUserSubject
    super.init(nibName: Nibs.searchResultsView, bundle: Bundle.main)
  }

  deinit { print("\(self) deinited") }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SearchResultsVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = []
    configureCollection()
    configureViewBindings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureInitialConstraints()
    searchResultsViewModel.emptyUsersSubject(resultUsersSubject)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onAppearAnimations()
  }
}

private extension SearchResultsVC {
  func configureCollection() {
    searchResultsCollection.register(UINib(nibName: Nibs.searchUserResultItem, bundle: Bundle.main), forCellWithReuseIdentifier: Nibs.searchUserResultItem)
  }

  func configureViewBindings() {
    bindResultsCollection()
    bindItemSelected()
  }
}

private extension SearchResultsVC {
  func bindResultsCollection() {
    resultUsersSubject?
      .asObservable()
      .bind(to: searchResultsCollection.rx.items(cellIdentifier: Nibs.searchUserResultItem, cellType: SearchUserResultItem.self)) { _, user, item in
        item.resultUser = user
      }
      .disposed(by: disposeBag)
  }

  func bindItemSelected() {
    searchResultsCollection
      .rx
      .modelSelected(UserProfile.self)
      .subscribe(onNext: { [weak self] userProfile in
        // Update emit new CurrentuserRelay for selected user
        print("User selected: \(userProfile.name)")
        self?.currentUserRelay?.accept(userProfile)
        self?.searchingUserSubject.onNext(false)

      })
      .disposed(by: disposeBag)
  }
}

private extension SearchResultsVC {
  func configureInitialConstraints() {
    searchHelpTopAnchor.priority = UILayoutPriority(998)
  }
}

private extension SearchResultsVC {
  func onAppearAnimations() {
    searchHelpTopAnchor.priority = UILayoutPriority(1000)
    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: []) {
      self.searchHelpLabel.superview?.layoutIfNeeded()
    }
  }
}
