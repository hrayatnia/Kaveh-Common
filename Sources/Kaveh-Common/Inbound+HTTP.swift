

@frozen public struct InboundHTTPSettings: Codable {
    var allowTransparent: Bool = false
    var userLevel: Int = 0
    var accounts: [InboundHTTPAccount] = []
}

@frozen public struct InboundHTTPAccount: Codable {
    var user: String = ""
    var pass: String = ""
}
