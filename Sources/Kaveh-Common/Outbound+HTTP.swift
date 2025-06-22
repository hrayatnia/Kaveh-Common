import MemberwiseInit

/// Settings for HTTP outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundHTTPSettings: Codable {
    public var servers: [OutboundHTTPServer] = []
    
    init(){}
    public init(host: String, port: Int = 443, user: String, pass: String) {
        var server = OutboundHTTPServer(address: host, port: port)
        let user = OutboundHTTPUser(user: user, pass: pass)
        server.users.append(user)
        self.servers.append(server)
    }
}

/// HTTP server settings.
@MemberwiseInit(.public)
@frozen public struct OutboundHTTPServer: Codable {
    public var address: String = ""
    public var port: Int = 8080
    public var users: [OutboundHTTPUser] = []
}

/// HTTP user settings.
@MemberwiseInit(.public)
@frozen public struct OutboundHTTPUser: Codable {
    public var user: String = ""
    public var pass: String = ""
}
