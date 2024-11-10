//
//  ModelTests.swift
//  FetchRecipe
//
//  Created by Ryan Secrest on 11/9/24.
//

import Foundation
import XCTest
@testable import RecipeApp

final class RecipeModelTests: XCTestCase {
    func testRecipeDecoding() throws {
        let json = """
        {
           "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
           "cuisine": "Malaysian",
           "name": "Apam Balik",
           photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
           "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        }
        """.data(using: .utf8)!
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        XCTAssertEqual(recipe.name, "Bakewell Tart")
        XCTAssertEqual(recipe.cuisin, "British")
        XCTAssertEqual(recipe.id.uuidString, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
}
