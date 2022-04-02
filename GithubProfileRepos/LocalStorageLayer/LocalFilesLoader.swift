//
//  JSONLoader.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 1/04/22.
//

import Foundation

protocol BundleFileType {
  associatedtype ObjectType: Decodable
  var object: ObjectType.Type { get }
  var path: String { get }
  var fileExtension: String { get }
}

enum JSONFileType: BundleFileType {
  typealias ObjectType = RepoLanguages
  var object: ObjectType.Type { return ObjectType.self }
  var path: String { return "" }
  var fileExtension: String { return "json" }
}

protocol LocalFilesLoaderProtocol {
  associatedtype FileType: BundleFileType
  func loadFileFromLocal(file: FileType)
}

struct LocalFilesLoader: LocalFilesLoaderProtocol {
  typealias FileType = JSONFileType
  func loadFileFromLocal(file: FileType) {
    print("sdfa")
//    if let url = Bundle.main.url(forResource: file.path, withExtension: file.fileExtension) {
//      do {
//        let data = try Data(contentsOf: url)
//        _ = try JSONDecoder().decode(file.object, from: data)
    ////        return jsonData
//      } catch {}
//    }
  }
}
