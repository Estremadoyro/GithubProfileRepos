//
//  File.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 12/04/22.
//

import Foundation
import RxCocoa
import RxSwift

enum SearchError: Error {
  case underlyingError(Error)
  case notFound
  case unknowned
}

final class HomeSearchBarViewModel {
  var networkManager: NetworkManager?
  lazy var disposeBag = DisposeBag()

  // Subjects (Inputs)
  let searchSubject = PublishSubject<String>()
  var searchObserver: AnyObserver<String> {
    return searchSubject.asObserver()
  }

  // Outputs
  let loadingSubject = PublishSubject<Bool>()
  var isLoading: Driver<Bool> {
    return loadingSubject
      .asDriver(onErrorJustReturn: false)
  }

  let errorSubject = PublishSubject<SearchError?>()
  var error: Driver<SearchError?> {
    return errorSubject
      .asDriver(onErrorJustReturn: SearchError.unknowned)
  }

  // Users obtained while searching
  let resultUsersSubject = PublishSubject<[UserProfile]>()
  let searchingUserSubject = PublishSubject<Bool>()

  init() {
    configureBindings()
  }
}

extension HomeSearchBarViewModel {
  func searchUser(username: String) -> Observable<[UserProfile]> {
    print("USER SEARCHING: \(username)")
    return Observable<[UserProfile]>.create { [weak self] observer in
      self?.networkManager?.getUser(username: username, mocking: true, completion: { user, error in
        if let error = error {
          print("ERROR: \(error)")
          observer.onError(error)
        }
        if let user = user {
          print("USERS FOUND: \(user)")
          observer.onNext([user])
          observer.onCompleted()
        }
      })
      return Disposables.create()
    }
  }
}

private extension HomeSearchBarViewModel {
  func configureBindings() {
    searchSubject
      .asObservable() // specifiying the Subject's current role
      .filter { !$0.isEmpty } // prevents empty
      .distinctUntilChanged() // prevents duplicates
      .debounce(.seconds(1), scheduler: MainScheduler.instance) // Ignore any element coming before 1 seconds
      .flatMapLatest { [unowned self] searchInput -> Observable<[UserProfile]> in
        self.loadingSubject.onNext(true)
        self.errorSubject.onNext(nil)
        return searchUser(username: searchInput)
          .catch { error -> Observable<[UserProfile]> in
            self.loadingSubject.onNext(false)
            self.errorSubject.onNext(SearchError.underlyingError(error))
            return Observable.empty()
          }
      }
      .subscribe(onNext: { [weak self] usersProfile in
        self?.loadingSubject.onNext(false)
        self?.errorSubject.onNext(nil)
        print("USER RESULT: \(usersProfile.first?.name ?? "")")
        if usersProfile.isEmpty {
          self?.errorSubject.onNext(SearchError.notFound)
          print("UserProfile was empty")
        } else {
          // User found
          // Update the Result's Collection View
          print("Update current user to: \(usersProfile.first?.name ?? "")")
          self?.resultUsersSubject.onNext(usersProfile)
        }
      })
      .disposed(by: disposeBag)
  }
}
