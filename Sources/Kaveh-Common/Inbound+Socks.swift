import MemberwiseInit

/// Settings for Socks inbound protocol.
@MemberwiseInit(.public)
@frozen public struct InboundSocksSettings: Codable {
    public var udp: Bool = false
    public var ip: String = ""
    
    enum CodingKeys: CodingKey {
        case udp, ip
    }
    public init(udp: Bool = false) {
        self.udp = udp
    }
  public init (from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        udp = try container.decodeIfPresent(Bool.self, forKey: .udp) ?? false
        ip = try container.decodeIfPresent(String.self, forKey: .ip) ?? ""
    }
    
  public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if udp {
            try container.encode(udp, forKey: .udp)
        }
        if udp && !ip.isEmpty {
            try container.encode(ip, forKey: .ip)
        }
    }
}
