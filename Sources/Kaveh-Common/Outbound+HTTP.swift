

@frozen public struct OutboundHTTPSettings: Codable {
    var servers: [OutboundHTTPServer] = []
    
    init(){}
    init(host: String, port: Int = 443, user: String, pass: String) {
        var server = OutboundHTTPServer(address: host, port: port)
        let user = OutboundHTTPUser(user: user, pass: pass)
        server.users.append(user)
        self.servers.append(server)
    }
}

@frozen public struct OutboundHTTPServer: Codable {
    var address: String = ""
    var port: Int = 8080
    var users: [OutboundHTTPUser] = []
}

@frozen public struct OutboundHTTPUser: Codable {
    var user: String = ""
    var pass: String = ""
}
