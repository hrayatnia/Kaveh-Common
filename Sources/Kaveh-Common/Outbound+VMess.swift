import SwiftUI
import MemberwiseInit

/// Settings for VMess outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundVMESSSettings: Codable {
    public var vnext: [OutboundVMESSServer] = []
    
    init(){}
    init(host: String, port: Int, user: String, security: String) {
        var server = OutboundVMESSServer(address: host, port: port)
        let user = OutboundVMESSUser(id: user, security: security)
        server.users.append(user)
        self.vnext.append(server)
    }
}

/// VMess server settings.
@MemberwiseInit(.public)
@frozen public struct OutboundVMESSServer: Codable {
    public var address: String = ""
    public var port: Int = 443
    public var users: [OutboundVMESSUser] = []
}

/// VMess user settings.
@MemberwiseInit(.public)
@frozen public struct OutboundVMESSUser: Codable {
    public var id: String = ""
    public var security: String = "auto"
    public var level: Int = 0
    public var experiments: String = ""
}
