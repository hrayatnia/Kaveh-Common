import Foundation.NSCoder

/// A report containing metrics statistics.
@frozen public struct MetricsReport: Codable {
    /// The statistics for the report.
    let stats: MetricsStats
}

/// Statistics for inbound and outbound traffic.
@frozen public struct MetricsStats: Codable {
    /// Inbound traffic metrics, keyed by tag.
    let inbound: [String: MetricsTraffic]
    /// Outbound traffic metrics, keyed by tag.
    let outbound: [String: MetricsTraffic]
}

/// Traffic metrics for a single direction.
@frozen public struct MetricsTraffic: Codable {
    /// Uplink traffic in bytes.
    let uplink: Int
    /// Downlink traffic in bytes.
    let downlink: Int
}

extension MetricsReport {
    /// Queries the metrics report from a local debug endpoint.
    /// - Parameter port: The port to query.
    /// - Returns: The decoded MetricsReport.
    /// - Throws: An error if the request or decoding fails.
    static func queryReport(_ port: Int) async throws -> MetricsReport {
        let url = URL(string: "http://127.0.0.1:\(port)/debug/vars")!
        let urlSession = URLSession.shared
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(MetricsReport.self, from: data)
    }
}
