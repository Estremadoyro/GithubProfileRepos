//
//  GithubProfileReposTests.swift
//  GithubProfileReposTests
//
//  Created by Leonardo  on 15/05/22.
//

import XCTest

// Importing the GithubProfileRepos project
@testable import GithubProfileRepos

class GithubProfileReposTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testGetMostUsedLanguage() throws {
    // Given
    let languages: RepoLanguages = ["javascript": 100, "python": 200, "swift": 300]
    // When
    let mostUsedLanguage: RepoLanguages.Element = Utils.getMostUsedLanguage(languages: languages)
    // Then
    let expectedMostUsedLanguageKey: String = "swift"
    let expectedMostUsedLanguageValue: Int = 300
    XCTAssert(mostUsedLanguage.key.contains(expectedMostUsedLanguageKey))
    XCTAssert(mostUsedLanguage.value == expectedMostUsedLanguageValue)
  }

  func testGetColorByRepoLanguage() throws {
    // Given
    let language: RepoLanguages.Element = ["swift": 300].first!
    // When
    let mostUsedLanguageColor: ColorByLanguage.Element = Utils.getColorByRepoLanguage(repoLanguage: language)
    // Then
    let expectedMostUsedLanguageColorKey: String = "swift"
    let expectedMostUsedLanguageColorValue = UIColor.systemPink
    // Asserts
    XCTAssert(mostUsedLanguageColor.key.contains(expectedMostUsedLanguageColorKey))
    XCTAssert(mostUsedLanguageColor.value == expectedMostUsedLanguageColorValue)
  }
}
