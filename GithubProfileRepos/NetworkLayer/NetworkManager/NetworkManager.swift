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
  func getUser(username: String, mocking: Bool, completion: @escaping GithubUserCompletion) {
    if mocking {
      LocalStorageManager.loadMock(fileName: "User", obj: UserProfile.self) { data in
        guard let data = data else { completion(nil, NetworkResponse.noData); return }
        completion(data, nil)
      }
      return
    }
    router.request(.user(username: username)) { data, response, error in
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
              let apiReponse = try JSONDecoder().decode(UserProfile.self, from: responseData)
              completion(apiReponse, nil)
            } catch {
              completion(nil, NetworkResponse.unableToDecode)
            }
          case .failure(let networkFailureError):
            print("ERROR CODE: \(response.statusCode)")
            completion(nil, networkFailureError)
        }
      }
    }
  }

  func getReposByUsername(username: String, mocking: Bool = false, completion: @escaping GithubUserReposCompletion) {
    if mocking {
      LocalStorageManager.loadMock(fileName: "UserRepos", obj: [Repo].self) { data in
        guard let data = data else { completion(nil, NetworkResponse.noData); return }
        completion(data, nil)
      }
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

  func getUserFollowers(username: String, mocking: Bool, completion: @escaping GithubUserFollowersCompletion) {
    if mocking {
      LocalStorageManager.loadMock(fileName: "UserFollowers", obj: Followers.self) { data in
        guard let data = data else { completion(nil, NetworkResponse.noData); return }
        completion(data, nil)
      }
      return
    }
    router.request(.userFollowers(username: username)) { data, response, error in
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
              let apiReponse = try JSONDecoder().decode(Followers.self, from: responseData)
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

  func getUserFollowing(username: String, mocking: Bool, completion: @escaping GithubUserFollowingCompletion) {
    if mocking {
      LocalStorageManager.loadMock(fileName: "UserFollowing", obj: Following.self) { data in
        guard let data = data else { completion(nil, NetworkResponse.noData); return }
        completion(data, nil)
      }
      return
    }
    router.request(.userFollowing(username: username)) { data, response, error in
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
              let apiReponse = try JSONDecoder().decode(Following.self, from: responseData)
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
      LocalStorageManager.loadMock(fileName: "RepoLanguages", obj: RepoLanguage.self) { data in
        guard let data = data else { return }
        completion(data, nil)
      }
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
              let apiReponse = try JSONDecoder().decode(RepoLanguage.self, from: responseData)
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
    case notFound = "Not found"
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
      case 401: return .failure(networkFailureError: NetworkResponse.authenticationError)
      case 404: return .failure(networkFailureError: NetworkResponse.notFound)
      case 501 ... 599: return .failure(networkFailureError: NetworkResponse.badRequest)
      case 600: return .failure(networkFailureError: NetworkResponse.outdated)
      default: return .failure(networkFailureError: NetworkResponse.failed)
    }
  }
}
