
import SwiftUI

@frozen public struct InboundVLESSSettings: Codable {
    var decryption: String = ""
    var clients: [InboundVLESSClient] = []
    var fallbacks: [InboundVLESSFallback]?
}

@frozen public struct InboundVLESSClient: Codable {
    var id: String
    var level: Int
    var email: String?
    var flow: String?
}

@frozen public struct InboundVLESSFallback: Codable {
    var dest: Int
    var xver: Int?
    var alpn: String?
    var path: String?
}
