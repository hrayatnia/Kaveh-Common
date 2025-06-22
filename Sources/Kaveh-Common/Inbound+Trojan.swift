import SwiftUI
import MemberwiseInit
//
/// Settings for Trojan inbound protocol.
@MemberwiseInit(.public)
@frozen public struct InboundTrojanSettings: Codable {
    public var clients: [InboundTrojanClient] = []
    public var fallbacks: [InboundTrojanFallback]?
}

/// Trojan client settings.
@MemberwiseInit(.public)
@frozen public struct InboundTrojanClient: Codable {
    public var password: String
    public var email: String?
    public var level: Int
}

/// Trojan fallback settings.
@MemberwiseInit(.public)
@frozen public struct InboundTrojanFallback: Codable {
    public var dest: Int
    public var xver: Int?
    public var alpn: String?
}
