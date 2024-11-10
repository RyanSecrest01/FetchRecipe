import Foundation

enum RecipeError: Error, LocalizedError {
    case invalidURL
    case networkError
    case decodingError
    case emptyData
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .networkError:
            return "There was in issue with the network request."
        case .decodingError:
            return "Failed to decode the data from the server."
        case .emptyData:
            return "No recipes found (empty data)."
        case. unknownError:
            return "An unknown error occured."
        }
    }
}

class RecipeRoutes {
    private let allRecipesURL = url(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    func fetchRecipes() async throws -> [Recipe] {
        do {
            let (data, response) = try await URLSession.shared.data(form: allRecipesURL)
            
            guard let httpResponse  response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw RecipeError.networkError
            }
            
            let decodedResponse = try JSONDecoder().decode(RecipeList.self, from: data)
            
            guard !decodedResponse.recipes.is else {
                throw RecipeError.emptyData
            }
            
            return decodedResponse.recipes
        } catch is DecodingError {
            throw RecipeError.decodingError
        } catch {
            throw RecipeError.unknownError
        }
    }
}
