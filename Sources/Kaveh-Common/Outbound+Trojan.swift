import MemberwiseInit

/// Settings for Trojan outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundTrojanSettings: Codable {
    public var servers: [OutboundTrojanServer] = []
    
    init(){}
    public init(host: String, port: Int = 443, password: String) {
        var server = OutboundTrojanServer()
        server.address = host
        server.port = port
        server.password = password
        self.servers.append(server)
    }
}

/// Trojan server settings.
@MemberwiseInit(.public)
@frozen public struct OutboundTrojanServer: Codable {
    public var address: String = ""
    public var port: Int = 443
    public var password: String = ""
}
