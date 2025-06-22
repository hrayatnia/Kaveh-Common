import SwiftUI
import MemberwiseInit

/// Settings for VLESS outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundVLESSSettings: Codable {
    public var vnext: [OutboundVLESSServer] = []
    
    init(){}
    init(host: String, port: Int, id: String, flow: String? = nil) {
        vnext.append(OutboundVLESSServer(address: host, port: port, users: [OutboundVLESSUser(id: id, flow: flow)]))
    }
}

/// VLESS server settings.
@MemberwiseInit(.public)
@frozen public struct OutboundVLESSServer: Codable {
    public var address: String = ""
    public var port: Int = 443
    public var users: [OutboundVLESSUser] = []
}

/// VLESS user settings.
@MemberwiseInit(.public)
@frozen public struct OutboundVLESSUser: Codable {
    public var id: String = ""
  @Init(.ignore) var encryption: String = "none"
    public var flow: String?
  @Init(.ignore) var level: Int? = 0
}
