//
//  NetworkManager.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import Foundation

enum NetworkEnvironment {
  case develop
  case production
}

/// # HANDLES THE REQUEST STATUS AND COMPLETION
/// Accessible by other layers
struct NetworkManager {
  static let environment: NetworkEnvironment = .develop
  static let githubApiKey = Keys.githubApiKey
  fileprivate let router = Router<GithubUsersEndpoint>()
}

extension NetworkManager: NetworkRequestsProtocol {
  func getReposByUsername(username: String, mocking: Bool = false, completion: @escaping GithubUserReposCompletion) {
    print("API REQUEST ABOUT TO START OWO")
    if mocking {
      LocalStorageManager.loadMock(fileName: "UserRepos", obj: [Repo].self) { data in
        guard let data = data else { completion(nil, NetworkResponse.noData); return }
        completion(data, nil)
      }
      print("Repos mocking")
      return
    }
    router.request(.reposByUsername(username: username)) { data, response, error in
      print("API REQUEST RESPONSE")
      if error != nil {
        completion(nil, NetworkResponse.errorFound)
        return
      }

      if let response = response as? HTTPURLResponse {
        let result = handleNetworkResponse(response)
        switch result {
          case .success:
            guard let responseData = data else {
              completion(nil, NetworkResponse.noData)
              return
            }
            do {
              let apiReponse = try JSONDecoder().decode([Repo].self, from: responseData)
              completion(apiReponse, nil)
            } catch {
              completion(nil, NetworkResponse.unableToDecode)
            }
          case .failure(let networkFailureError):
            completion(nil, networkFailureError)
        }
      }
    }
  }

  func getLanguagesByRepo(repo: Repo, mocking: Bool = false, completion: @escaping GithubRepoLanguagesCompletion) {
    if mocking {
      LocalStorageManager.loadMock(fileName: "RepoLanguages", obj: RepoLanguages.self) { data in
        guard let data = data else { return }
        completion(data, nil)
      }
      print("Languages mocking")
      return
    }
    router.request(.languagesByRepo(repo: repo)) { data, response, error in
      if error != nil {
        completion(nil, NetworkResponse.errorFound)
        return
      }

      if let response = response as? HTTPURLResponse {
        let result = handleNetworkResponse(response)
        switch result {
          case .success:
            guard let responseData = data else {
              completion(nil, NetworkResponse.noData)
              return
            }
            do {
              let apiReponse = try JSONDecoder().decode(RepoLanguages.self, from: responseData)
              print("Languages data: \(apiReponse)")
              completion(apiReponse, nil)
            } catch {
              completion(nil, NetworkResponse.unableToDecode)
            }
          case .failure(let networkFailureError):
            completion(nil, networkFailureError)
        }
      }
    }
  }
}

private extension NetworkManager {
  enum Result<T: Error> {
    case success
    case failure(networkFailureError: T)
  }

  enum NetworkResponse: String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case errorFound = "Request error found"
  }

  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<NetworkResponse> {
    switch response.statusCode {
      case 200 ... 299: return .success
      case 401 ... 500: return .failure(networkFailureError: NetworkResponse.authenticationError)
      case 501 ... 599: return .failure(networkFailureError: NetworkResponse.badRequest)
      case 600: return .failure(networkFailureError: NetworkResponse.outdated)
      default: return .failure(networkFailureError: NetworkResponse.failed)
    }
  }
}
