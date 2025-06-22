

@frozen public struct OutboundBlackholeSettings: Codable {
    var response: OutboundBlackholeResponse?
    
    init(responseType: String) {
        response = OutboundBlackholeResponse()
        response!.type = responseType
    }
}

@frozen public struct OutboundBlackholeResponse: Codable {
    var type: String = "none"
}
