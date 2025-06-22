import MemberwiseInit

/// Settings for Shadowsocks outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundShadowsocksSettings: Codable {
    public var servers: [OutboundShadowsocksServer] = []
    
    init(){}
    init(host: String, port: Int, pass: String, method: String){
      servers
        .append(
          OutboundShadowsocksServer(
            address: host,
            port: port,
            email: nil,
            password: pass,
            method: method
          )
        )
    }
}

/// Shadowsocks server settings.
@MemberwiseInit(.public)
@frozen public struct OutboundShadowsocksServer: Codable {
    public var address: String = ""
    public var port: Int = 1234
    public var email: String?
    public var password: String = ""
    public var method: String = ""
    public var uot: Bool = true
    public var level: Int = 0
}
