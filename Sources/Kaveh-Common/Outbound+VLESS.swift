
import SwiftUI

@frozen public struct OutboundVLESSSettings: Codable {
    var vnext: [OutboundVLESSServer] = []
    
    init(){}
    init(host: String, port: Int, user: String, encryption: String = "", flow: String = "", level: Int = 0) {
        var server = OutboundVLESSServer(address: host, port: port)
        server.users.append(OutboundVLESSUser(
            id: user,
            encryption: encryption,
            flow: flow,
            level: level
        ))
        self.vnext.append(server)
    }
}

@frozen public struct OutboundVLESSServer: Codable {
    var address: String = ""
    var port: Int = 443
    var users: [OutboundVLESSUser] = []
}

@frozen public struct OutboundVLESSUser: Codable {
    var id: String = ""
    var encryption: String = "none"
    var flow: String? = ""
    var level: Int? = 0
}
