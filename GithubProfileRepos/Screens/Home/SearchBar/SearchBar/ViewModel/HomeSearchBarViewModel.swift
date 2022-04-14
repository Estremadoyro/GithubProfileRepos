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

class HomeSearchBarViewModel {
  var networkManager: NetworkManager?

  // The CurrentUserSequence should be injected
  // here...

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
}

extension HomeSearchBarViewModel {
  func searchUser(username: String) -> Observable<UserProfile> {
    print("USER SEARCHING: \(username)")
    return Observable<UserProfile>.create { [weak self] observer in
      self?.networkManager?.getUser(username: username, mocking: true, completion: { user, error in
        if let error = error { observer.onError(error) }
        if let user = user { observer.onNext(user) }
      })
      return Disposables.create()
    }
  }
//  func updateUserResultsSequence(username: String) {
//    networkManager?.getUser(username: username, mocking: true, completion: { [weak self] user, error in
//      if let error = error { self?.userResultsObservable.onError(error) }
//      if let user = user { self?.userResultsObservable.onNext(user) }
//      print("FOUND USER: \(user?.name ?? "")")
//    })
//  }
}
