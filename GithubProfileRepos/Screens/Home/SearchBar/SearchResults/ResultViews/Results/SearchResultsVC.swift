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
final class SearchResultsVC: UIViewController, UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
  }
  
  @IBOutlet private weak var searchHelpLabel: UILabel!
  @IBOutlet private weak var searchHelpTopAnchor: NSLayoutConstraint!
  @IBOutlet private weak var searchResultsCollection: UICollectionView!

  // Views
  fileprivate var loadingView: UIView?
  fileprivate var emptyView: UIView?

  // ViewModel
  var searchResultsViewModel: SearchResultsViewModel?

  // Injected properties
  weak var currentUserRelay: PublishRelay<UserProfile>?
  weak var resultUsersSubject: PublishSubject<[UserProfile]>?
  var searchingResultLoading: Driver<Bool>
  var searchingResultError: Driver<SearchError?>
  let searchBarShowingSubject: PublishSubject<Bool>

  fileprivate var disposeBag: DisposeBag?

  init(currentUserRelay: PublishRelay<UserProfile>,
       resultUsersSubject: PublishSubject<[UserProfile]>,
       searchingUserSubject: PublishSubject<Bool>,
       searchingResultLoading: Driver<Bool>,
       searchingResultError: Driver<SearchError?>)
  {
    self.currentUserRelay = currentUserRelay
    self.resultUsersSubject = resultUsersSubject
    self.searchBarShowingSubject = searchingUserSubject
    self.searchingResultLoading = searchingResultLoading
    self.searchingResultError = searchingResultError
    super.init(nibName: Xibs.searchResultsView, bundle: Bundle.main)
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
    configureViews()
    configureCollection()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchResultsViewModel = SearchResultsViewModel()
    disposeBag = DisposeBag()
    configureViewBindings()
    configureInitialConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("SearchResultsDidAppear")
    onAppearAnimations()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    print("SearchResultsDidDisappear")
    searchResultsViewModel?.emptyUsersSubject(resultUsersSubject)
    searchResultsViewModel = nil
    disposeBag = nil
  }
}

private extension SearchResultsVC {
  func configureViews() {
    loadingView = Bundle.main.loadNibNamed(Xibs.searchLoadingView, owner: self, options: nil)![0] as? UIView
    emptyView = Bundle.main.loadNibNamed(Xibs.searchResultEmptyView, owner: self, options: nil)![0] as? UIView
    print("XIBS loaded")

    guard let loadingView = loadingView, let emptyView = emptyView else { return }

    emptyView.isHidden = true
    loadingView.isHidden = true
//    searchResultsCollection.isHidden = true
    view.addSubview(emptyView)
    view.addSubview(loadingView)

    let views: [UIView] = [loadingView, emptyView]
    views.forEach { customView in
      NSLayoutConstraint.activate([
        customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
        customView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
    }
  }

  func configureCollection() {
    searchResultsCollection.register(UINib(nibName: Xibs.searchUserResultItem, bundle: Bundle.main), forCellWithReuseIdentifier: Xibs.searchUserResultItem)
  }

  func configureViewBindings() {
    guard let disposeBag = disposeBag else { fatalError("No disposebag set for: \(self)") }
    bindResultsCollection(disposeBag)
    bindItemSelected(disposeBag)
    bindResultViews(disposeBag)
  }
}

private extension SearchResultsVC {
  func bindResultsCollection(_ disposeBag: DisposeBag) {
    resultUsersSubject?
      .asObservable()
      .bind(to: searchResultsCollection.rx.items(cellIdentifier: Xibs.searchUserResultItem, cellType: SearchUserResultItem.self)) { _, user, item in
        item.resultUser = user
      }
      .disposed(by: disposeBag)
  }

  func bindItemSelected(_ disposeBag: DisposeBag) {
    searchResultsCollection
      .rx
      .modelSelected(UserProfile.self)
      .subscribe(onNext: { [weak self] userProfile in
        // Update emit new CurrentuserRelay for selected user
        print("User selected: \(userProfile.name)")
        self?.currentUserRelay?.accept(userProfile)
        self?.searchBarShowingSubject.onNext(false)

      })
      .disposed(by: disposeBag)
  }

  func bindResultViews(_ disposeBag: DisposeBag) {
    // Binding ResultsCollectionView
    searchingResultLoading
      .drive(searchResultsCollection.rx.isHidden)
      .disposed(by: disposeBag)

    searchingResultError
      .map { $0 != nil }
      .drive(searchResultsCollection.rx.isHidden)
      .disposed(by: disposeBag)

    // Binding SearchLoadingView
    if let loadingView = loadingView {
      searchingResultLoading
        .map(!)
        .drive(loadingView.rx.isHidden)
        .disposed(by: disposeBag)
    }

    // Bind SearchErrorView
    if let emptyView = emptyView {
      searchingResultError
        .map { $0 == nil }
        .drive(emptyView.rx.isHidden)
        .disposed(by: disposeBag)
    }
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
