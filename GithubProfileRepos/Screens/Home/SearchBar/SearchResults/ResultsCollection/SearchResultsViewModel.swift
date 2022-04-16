//
//  SearchResultsViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 14/04/22.
//

import RxSwift

final class SearchResultsViewModel {
  func emptyUsersSubject(_ resultUsersSubject: PublishSubject<[UserProfile]>?) {
    guard let resultUsersSubject = resultUsersSubject else { return }
    resultUsersSubject.onNext([UserProfile]())
  }
}
