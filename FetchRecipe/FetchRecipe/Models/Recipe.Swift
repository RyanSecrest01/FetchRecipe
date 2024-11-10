struct Recipe: Identifiable, Codable {
    let id: UUID
    let cuisine: String
    let name: String
    let photo_url_large : URL?
    let photo_url_small : URL?
    let sourceUrl: URL?
    let youtube_url: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine, name
        case photo_url_large = "photo_url_large"
        case photo_url_small = "photo_url_small"
        case sourceUrl = "source_url"
        case youtube_url = "youtube_url"
    }

}

struct RecipeList: Codable {
    let recipes: [Recipe]
}
