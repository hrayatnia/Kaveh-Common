
import SwiftUI

@frozen public struct OutboundVMESSSettings: Codable {
    var vnext: [OutboundVMESSServer] = []
    
    init(){}
    init(host: String, port: Int, user: String, security: String) {
        var server = OutboundVMESSServer(address: host, port: port)
        let user = OutboundVMESSUser(id: user, security: security)
        server.users.append(user)
        self.vnext.append(server)
    }
}

@frozen public struct OutboundVMESSServer: Codable {
    var address: String = ""
    var port: Int = 443
    var users: [OutboundVMESSUser] = []
}

@frozen public struct OutboundVMESSUser: Codable {
    var id: String = ""
    var security: String = "auto"
    var level: Int = 0
    var experiments: String = ""
}
