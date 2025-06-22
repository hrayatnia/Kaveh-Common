import MemberwiseInit

/// Settings for HTTP inbound protocol.
@MemberwiseInit(.public)
@frozen public struct InboundHTTPSettings: Codable {
    public var allowTransparent: Bool = false
    public var userLevel: Int = 0
    public var accounts: [InboundHTTPAccount] = []
}

/// HTTP account settings.
@MemberwiseInit(.public)
@frozen public struct InboundHTTPAccount: Codable {
    public var user: String = ""
    public var pass: String = ""
}
