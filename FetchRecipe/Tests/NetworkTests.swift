//
//  NetworkTests.swift
//  FetchRecipe
//
//  Created by Ryan Secrest on 11/9/24.
//

import Foundation
@testable import FetchRecipe

final class NetworkTests: XCTestCase{
    
    private func setUpMockResponse(with data: Data?, statusCode: Int = 200) {
        let url = url(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        URLProtocalMock.requestHandler  { _ in (response, data)}
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        URLSession.shared = URLSession(configuration: config)
    }
    
    func testFetchRecipesSuccess() async throws {
        let jsonData = """
        {
            "recipes": [
                {
                   "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                   "cuisine": "Malaysian",
                   "name": "Apam Balik",
                   photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                   "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
                }
            ]
        }
        """.data(using: .utf8)
        
        setUpMockResponse(with: jsonData)
        let service = RecipeRoutes()
        let recipes = try await service.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
        XCTAssertEqual(recipes.first?.cuisin, "Malaysian")
    }
    
    func testFetchRecipesMalformedData() async {
        let malformedData = """
        {
            "recipes": [
                {
                  "cuisine": "British",
                  "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                  "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                }
            ]
        }
        """.data(using: .utf8)
        
        setUpMockResponse(with: malformedData)
        let service = RecipeRoutes()
        await XCTAssertThrowsError(try await service.fetchRecipes()) { error in XCTAssertEqual(error as? RecipeError, .decodingError)}
        
    }
 
    func testFetchRecipesEmptyData() async {
        let emptyData = """
        {
            "recipes": []
        }
        """.data(using: .utf8)
        
        setUpMockResponse(with: emptyData)
        let service = RecipeRoutes()
        await XCTAssertThrowsError(try await service.fetchRecipes()) {error in XCTAssertEqual( error as? RecipeError, .emptyData)}
    }
    
    func testFetchRecipesNetworkError() async {
        setUpMockResponse(with: nil, statusCode: 500)
        let service = RecipeService()
        await XCTAssertThrowsError(try await service.fetchRecipes()) {error in XCTAssertEqual(error as? RecipeError, .networkError)}
    }
}

