import MemberwiseInit

/// Settings for Blackhole outbound protocol.
@MemberwiseInit(.public)
@frozen public struct OutboundBlackholeSettings: Codable {
    public var response: OutboundBlackholeResponse?
    
    public init(responseType: String) {
        response = OutboundBlackholeResponse()
        response!.type = responseType
    }
}

/// Blackhole response settings.
@MemberwiseInit(.public)
@frozen public struct OutboundBlackholeResponse: Codable {
    public var type: String = "none"
}
