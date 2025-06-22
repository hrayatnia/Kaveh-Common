import SwiftUI
import MemberwiseInit

/// Settings for VLESS inbound protocol.
@MemberwiseInit(.public)
@frozen public struct InboundVLESSSettings: Codable {
    public var decryption: String = ""
    public var clients: [InboundVLESSClient] = []
    public var fallbacks: [InboundVLESSFallback]?
}

/// VLESS client settings.
@MemberwiseInit(.public)
@frozen public struct InboundVLESSClient: Codable {
    public var id: String
    public var level: Int
    public var email: String?
    public var flow: String?
}

/// VLESS fallback settings.
@MemberwiseInit(.public)
@frozen public struct InboundVLESSFallback: Codable {
    public var dest: Int
    public var xver: Int?
    public var alpn: String?
    public var path: String?
}
