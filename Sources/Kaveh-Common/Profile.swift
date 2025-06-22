import Foundation.NSCoder

// MARK: - Profile Model
/// Represents a user profile containing configuration and metadata.
@frozen public struct Profile: Identifiable, Codable {
  /// Unique identifier for the profile.
  public var id: UUID = UUID()
    // var url: String = "https://s1.trojanflare.one/clashx/1b996922-00ff-4795-b867-ddcc8511b6d4"
    /// Names of subscription proxies associated with this profile.
    var subscription_proxy_names: [String] = []
    /// The URL for the profile's configuration or subscription.
    var url: String = ""
    /// The display name of the profile.
    var name: String = ""
    /// The configuration associated with this profile.
    var config: Config = Config()
    /// The date the profile was created.
    var created_at: Date = Date()
    /// The date the profile was last updated.
    var updated_at: Date = Date()
}

extension Profile {
    /// Fetches proxies from the profile's subscription URL.
    /// - Returns: An array of Outbound configurations.
    /// - Throws: URLError if the URL is invalid or the response cannot be parsed.
    func fetchProxies() async throws -> [Outbound] {
        guard let url = URL(string: self.url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let content = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotParseResponse)
        }
        return try Config.parseShareLinks(content)
    }
}
