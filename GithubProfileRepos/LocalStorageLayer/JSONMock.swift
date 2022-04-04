//
//  JSONLoader.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 1/04/22.
//

import Foundation

enum BundleLoadingErrors: String, Error {
  case noFile = "No file found in bundle"
  case dataError = "Error converting file to data"
  case jsonError = "Error converting Data to Json"
}

enum JSONMock {
  static func loadFileFromBundle(from mockName: String) throws -> Data {
    guard let url = Bundle.main.url(forResource: mockName, withExtension: "json") else {
      print(BundleLoadingErrors.noFile.rawValue)
      throw BundleLoadingErrors.noFile
    }

    guard let data = try? Data(contentsOf: url) else {
      print(BundleLoadingErrors.dataError.rawValue)
      throw BundleLoadingErrors.dataError
    }

    return data
  }

  static func convertDataToJson<T: Decodable>(data: Data, from obj: T.Type) throws -> T {
    do {
      let jsonData = try JSONDecoder().decode(T.self, from: data)
      return jsonData
    } catch {
      print("\(BundleLoadingErrors.jsonError.rawValue) - \(error)")
      throw BundleLoadingErrors.jsonError
    }
  }
}

enum LocalStorageManager {
  static func loadMock<T: Decodable>(fileName: String, obj: T.Type, completion: (_: T?) -> Void) {
    do {
      let data = try JSONMock.loadFileFromBundle(from: fileName)
      let jsonData = try JSONMock.convertDataToJson(data: data, from: T.self)
      completion(jsonData)
    } catch BundleLoadingErrors.noFile, BundleLoadingErrors.dataError, BundleLoadingErrors.jsonError {
      completion(nil)
    } catch {
      print("Unexpected error: \(error)")
      completion(nil)
    }
  }
}
