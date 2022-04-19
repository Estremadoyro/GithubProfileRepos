//
//  HomeViewModel.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 28/03/22.
//

import Foundation
import RxSwift

final class ReposTableViewModel {
  // For sharing across cells, it's a struct tho, so no state is being managed
  var networkManager: NetworkManager?
}
