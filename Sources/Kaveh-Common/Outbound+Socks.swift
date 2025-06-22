import MemberwiseInit

/// Settings for Socks outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundSocksSettings: Codable {
    public var address: String = ""
    public var port: Int = 1080
    public var users: [OutboundSocksUser] = []
    
    init(){}
    public init(host: String, port: Int, user: String, pass: String, level: Int = 0) {
        self.address = host
        self.port = port
        self.users.append(OutboundSocksUser(user: user, pass: pass, level: level))
    }
}

/// Socks user settings.
@MemberwiseInit(.public)
@frozen public struct OutboundSocksUser: Codable {
    public var user: String = ""
    public var pass: String = ""
    public var level: Int = 0
}
