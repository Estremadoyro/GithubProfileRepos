//
//  HomeSearchBar.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 11/04/22.
//

import RxCocoa
import RxSwift
import UIKit

final class HomeSearchBar: UISearchController {
  fileprivate var searchSubjectDisposable: Disposable?
  fileprivate var searchBarDisposable: Disposable?
  fileprivate var searchingUserDisposable: Disposable?
  fileprivate var searchBarOnEnterDisposable: Disposable?
  fileprivate let disposeBag = CompositeDisposable()

  let homeSearchBarViewModel = HomeSearchBarViewModel()

  // Observables
  fileprivate lazy var searchSubject: PublishSubject<String> = homeSearchBarViewModel.searchSubject
  fileprivate lazy var searchingUserSubject: PublishSubject<Bool> = homeSearchBarViewModel.searchingUserSubject

  init(currentUserRelay: PublishRelay<UserProfile>) {
    print("Inited search controller")
    // Passing the current user for the CollectionView to handle
    super.init(searchResultsController: SearchResultsVC(
      currentUserRelay: currentUserRelay,
      resultUsersSubject: homeSearchBarViewModel.resultUsersSubject,
      searchingUserSubject: homeSearchBarViewModel.searchingUserSubject
    ))
    configureSearchBar()
  }

  deinit { print("\(self) deinited ") }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeSearchBar {
  /// # Only runs when user has tapped on the SearchBar
  /// Default configurations should be done in the init() method
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    let disposables: [Disposable?] = [
      searchBarDisposable,
      searchBarOnEnterDisposable,
      searchSubjectDisposable
    ]
    disposeSequences(disposables)
  }
}

private extension HomeSearchBar {
  func configureSearchBar() {
    showsSearchResultsController = true
    searchBar.placeholder = "Search Github"
  }
}

private extension HomeSearchBar {
  func configureBindings() {
    bindSearchBar()
  }

  func disposeSequences(_ disposables: [Disposable?]) {
    disposables.forEach { disposable in
      if let disposable = disposable, let disposableKey = disposeBag.insert(disposable) {
        disposeBag.remove(for: disposableKey)
      }
    }
  }
}

private extension HomeSearchBar {
  func bindSearchBar() {
//    searchBarDisposable = searchBar.rx.value.subscribe(onNext: { value in
//      print("value: \(value ?? "")")
//    }, onDisposed: { print("Searchbar disposed") })
//
//    searchBarOnEnterDisposable = searchBar.rx.searchButtonClicked
//      .subscribe(onNext: { [weak self] value in
//        let username: String = "\(value)"
//        self?.homeSearchBarViewModel.updateUserResultsSequence(username: username)
//        print("SEARCH: \(value)")
//      }, onDisposed: { print("searchBarOnEnterDisposable disposed") })

    // TODO: Fully understand the flatMap/conactMap operators, update CurrentUserRelay & bind with the SearchBarRxObservable
    searchSubjectDisposable = searchSubject
      .asObservable() // specifiying the Subject's current role
      .filter { !$0.isEmpty } // prevents empty
      .distinctUntilChanged() // prevents duplicates
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Ignore any element coming before 0.5 seconds
      .flatMapLatest { [unowned self] searchInput -> Observable<[UserProfile]> in
        self.homeSearchBarViewModel.errorSubject.onNext(nil)
        self.homeSearchBarViewModel.loadingSubject.onNext(true)
        return self.homeSearchBarViewModel.searchUser(username: searchInput)
          .catch { error -> Observable<[UserProfile]> in
            self.homeSearchBarViewModel.errorSubject.onNext(SearchError.underlyingError(error))
            return Observable.empty()
          }
      }
      .subscribe(onNext: { [weak self] usersProfile in
        self?.homeSearchBarViewModel.loadingSubject.onNext(false)
        print("USER RESULT: \(usersProfile.first?.name ?? "")")
        if usersProfile.isEmpty {
          self?.homeSearchBarViewModel.errorSubject.onNext(SearchError.notFound)
          print("UserProfile was empty")
        } else {
          // User found
          // Update the Result's Collection View
          print("Update current user to: \(usersProfile.first?.name ?? "")")
          self?.homeSearchBarViewModel.resultUsersSubject.onNext(usersProfile)
        }
      })

    searchBarDisposable = searchBar
      .rx
      .text
      .orEmpty
      .bind(to: homeSearchBarViewModel.searchObserver)

    searchingUserDisposable = searchingUserSubject
      .asObservable()
      .subscribe(onNext: { [weak self] status in
        self?.isActive = status
      })
  }
}
