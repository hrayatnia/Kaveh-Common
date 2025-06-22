
import SwiftUI
//
@frozen public struct InboundTrojanSettings: Codable {
    var clients: [InboundTrojanClient] = []
    var fallbacks: [InboundTrojanFallback]?
}

@frozen public struct InboundTrojanClient: Codable {
    var password: String
    var email: String?
    var level: Int
}

@frozen public struct InboundTrojanFallback: Codable {
    var dest: Int
    var xver: Int?
    var alpn: String?
}
