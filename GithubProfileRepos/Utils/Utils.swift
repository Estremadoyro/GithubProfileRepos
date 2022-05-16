//
//  Utils.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import Foundation
import UIKit

enum Utils {
  fileprivate static let errorColorByLanguage: ColorByLanguage.Element = ("Error language", LanguageColors.defaultColor)
  fileprivate static let errorNoLanguages: RepoLanguages.Element = ("error_language", 0)

  public static func getMostUsedLanguage(languages: RepoLanguages) -> RepoLanguages.Element {
    guard languages.count > 0 else { return errorNoLanguages } // No languages
    guard languages.count >= 2 else { return languages.first ?? errorNoLanguages } // 1 language
    guard let mostUsedLanguage = (languages.max { first, second in first.value < second.value }) else {
      return errorNoLanguages
    }
    return mostUsedLanguage
  }

  public static func getColorByRepoLanguage(repoLanguage: RepoLanguages.Element) -> ColorByLanguage.Element {
    guard let color = LanguageColors.colors[repoLanguage.key.lowercased()] else {
      return (repoLanguage.key, LanguageColors.defaultColor)
    }
    return (repoLanguage.key, color)
  }
}

extension Utils {
  public static func getUserAccumulatedStars(repos: [Repo]) -> Int {
    let reposStars = repos.map { $0.stars }
    return reposStars.reduce(0) { current, next in
      current + next
    }
  }

  public static func getUserTotalLinesOfCode(repos: [Repo]) -> Int {
    return 1
  }
}

extension Utils {
  enum ImageError: String, Error {
    case errorSource = "Error - No source"
    case errorUrl = "Error - Failed to convert source to URL"
    case errorRequest = "Error - Failed fetching the image data"
    case errorData = "Error - Failed accessing data"
  }

  typealias ImageFromSourceCompletion = (_ profilePicture: UIImage, _ error: Error?) -> Void

  public static func getImageFromSource(source: String?, completion: @escaping ImageFromSourceCompletion) {
    let placeholderImage = UIImage(named: "loading-image.png")!
    guard let source = source else { completion(placeholderImage, ImageError.errorSource); return }
    let session = URLSession.shared
    defer {
      session.invalidateAndCancel()
      session.finishTasksAndInvalidate()
    }
    guard let url = URL(string: source) else { completion(placeholderImage, ImageError.errorUrl); return }
    print("IMAGE URL \(url)")

    session.dataTask(with: url) { data, _, error in
      guard error == nil else {
        completion(placeholderImage, ImageError.errorRequest); return
      }
      guard let data = data, let image = UIImage(data: data) else { completion(placeholderImage, ImageError.errorData); return }
      completion(image, nil)
    }.resume()
  }
}
