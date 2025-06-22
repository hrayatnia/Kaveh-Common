import SwiftUI
import MemberwiseInit

public enum OutboundSetting {
    case http(OutboundHTTPSettings)
    case socks(OutboundSocksSettings)
    case vless(OutboundVLESSSettings)
    case vmess(OutboundVMESSSettings)
    case trojan(OutboundTrojanSettings)
    case shadowsocks(OutboundShadowsocksSettings)
    case freedom(OutboundFreedomSettings)
    case blackhole(OutboundBlackholeSettings)    
}

/// Represents an outbound configuration for the application.
@MemberwiseInit(.public)
@frozen public struct Outbound: Codable {
    public var tag: String = ""
    public var `protocol`: String = "freedom"
    public var settings: OutboundSetting = .freedom(OutboundFreedomSettings())
    public var streamSettings: StreamSettings = StreamSettings()
    public var mux: MuxSettings?
  
  public init(){}
    
    public var type: String {
        get { return self.protocol }
        set {
            if newValue == "trojan" {
                streamSettings.network = "raw"
                streamSettings.security = "tls"
            }
            self.protocol = newValue
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case tag
        case sendThrough
        case `protocol`
        case settings
        case streamSettings
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.protocol = try container.decode(String.self, forKey: .`protocol`)
        self.settings = .freedom(OutboundFreedomSettings()) // Default, adjust as needed
        self.streamSettings = try container.decodeIfPresent(StreamSettings.self, forKey: .streamSettings) ?? StreamSettings()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tag, forKey: .tag)
        try container.encode(`protocol`, forKey: .protocol)
        try container.encode(streamSettings, forKey: .streamSettings)
        
        switch settings {
        case .socks(let settings):
            try container.encode(settings, forKey: .settings)
        case .vless(let settings):
            try container.encode(settings, forKey: .settings)
        case .vmess(let settings):
            try container.encode(settings, forKey: .settings)
        case .trojan(let settings):
            try container.encode(settings, forKey: .settings)
        case .shadowsocks(let settings):
            try container.encode(settings, forKey: .settings)
        case .freedom(let settings):
            try container.encode(settings, forKey: .settings)
        case .blackhole(let settings):
            try container.encode(settings, forKey: .settings)
        case .http(let settings):
            try container.encode(settings, forKey: .settings)
        }
    }
    var isValid: Bool {
        return !tag.isEmpty
    }
    public static var direct : Outbound {
        var outbound = Outbound()
        outbound.tag = "direct"
        outbound.protocol = "freedom"
        return outbound
    }
    public static var block: Outbound {
        var outbound = Outbound()
        outbound.tag = "block"
        outbound.protocol = "blackhole"
        return outbound
    }
}

extension Outbound {
    func shareLink() -> String {
        var config = Config()
        config.outbounds = [self]
        let link = try? config.shareLinks().first!
        return link!
    }
}
