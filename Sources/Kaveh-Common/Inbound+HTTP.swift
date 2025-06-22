import MemberwiseInit

/// Settings for HTTP inbound protocol.
///
/// - Parameters:
///   - allowTransparent: Whether transparent proxying is allowed.
///   - userLevel: The user level for this inbound.
///   - accounts: The list of HTTP accounts.
@MemberwiseInit(.public)
@frozen public struct InboundHTTPSettings: Codable {
    /// Whether transparent proxying is allowed.
    public var allowTransparent: Bool = false
    /// The user level for this inbound.
    public var userLevel: Int = 0
    /// The list of HTTP accounts.
    public var accounts: [InboundHTTPAccount] = []
}

/// HTTP account settings.
///
/// - Parameters:
///   - user: The username for the account.
///   - pass: The password for the account.
@MemberwiseInit(.public)
@frozen public struct InboundHTTPAccount: Codable {
    /// The username for the account.
    public var user: String = ""
    /// The password for the account.
    public var pass: String = ""
}
