import Foundation.NSCoder
import UniformTypeIdentifiers.UTAdditions
import SwiftUI
import MemberwiseInit

/// Log configuration for the application.
@MemberwiseInit(.public)
@frozen public struct Log: Codable {
    public var access: String = "\(Common.accessLogPath)"
    public var error: String = "\(Common.errorLogPath)"
    public var loglevel: String = "warning"
}

/// Statistics configuration.
@MemberwiseInit(.public)
@frozen public struct Stats: Codable {}

/// API configuration.
@MemberwiseInit(.public)
@frozen public struct API: Codable {
    public var tag: String = ""
    public var services: [String]  = []
}

/// Policy configuration.
@MemberwiseInit(.public)
@frozen public struct Policy: Codable {
    public var system: PolicySystem?
  
  public init() {}
}

/// System-level policy configuration.
@MemberwiseInit(.public)
@frozen public struct PolicySystem: Codable {
    public var statsInboundUplink: Bool = false
    public var statsInboundDownlink: Bool = false
    public var statsOutboundUplink: Bool = false
    public var statsOutboundDownlink: Bool = false
    
    public static var enableAll: PolicySystem {
        return PolicySystem(
            statsInboundUplink: true,
            statsInboundDownlink: true,
            statsOutboundUplink: true,
            statsOutboundDownlink: true
        )
    }
}

/// Metrics configuration.
@MemberwiseInit(.public)
@frozen public struct Metrics: Codable {
    public var tag: String = "metrics-service"
}

/// Main configuration for the application.
@MemberwiseInit(.public)
@frozen public struct Config: Codable {
    public var log: Log?
    public var api: API?
    public var dns: DNS? = DNS.demo
    public var stats: Stats?
    public var metrics: Metrics?
    public var policy: Policy?
    public var routing: Routing = Routing()
    public var inbounds: [Inbound] = [Inbound.socks]
    public var outbounds: [Outbound] = [
        Outbound.direct,
        Outbound.block,
    ]
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.log = try container.decodeIfPresent(Log.self, forKey: .log)
    self.api = try container.decodeIfPresent(API.self, forKey: .api)
    self.dns = try container.decodeIfPresent(DNS.self, forKey: .dns)
    self.stats = try container.decodeIfPresent(Stats.self, forKey: .stats)
    self.metrics = try container.decodeIfPresent(Metrics.self, forKey: .metrics)
    self.policy = try container.decodeIfPresent(Policy.self, forKey: .policy)
    self.routing = try container.decode(Routing.self, forKey: .routing)
    self.inbounds = try container.decode([Inbound].self, forKey: .inbounds)
    self.outbounds = try container.decode([Outbound].self, forKey: .outbounds)
  }
  
  public init(){}
}

/// Stream settings for outbound connections.
@MemberwiseInit(.public)
@frozen public struct StreamSettings: Codable {
    public var network: String = "raw"
    public var security: String = "none"
    public var rawSettings: RawSettings = RawSettings()
    public var tlsSettings: TLSSettings = TLSSettings()
    public var realitySettings: RealitySetting = RealitySetting()
    public var wsSettings: WebSocketSettings = WebSocketSettings()
    public var httpUpgradeSettings: HTTPUpgradeSettings = HTTPUpgradeSettings()
    private enum CodingKeys: String, CodingKey {
        case network, security, rawSettings, tlsSettings, wsSettings, httpUpgradeSettings, realitySettings
    }
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        network = try container.decode(String.self, forKey: .network)
        security = try container.decode(String.self, forKey: .security)
        if network == "tcp" { rawSettings =  try container.decode(RawSettings.self, forKey: .rawSettings) }
        if network == "raw" { rawSettings =  try container.decode(RawSettings.self, forKey: .rawSettings) }
        if network == "ws" { wsSettings = try container.decode(WebSocketSettings.self, forKey: .wsSettings) }
        if security == "tls" { tlsSettings = try container.decode(TLSSettings.self, forKey: .tlsSettings) }
        if security == "reality" { realitySettings = try container.decode(RealitySetting.self, forKey: .realitySettings) }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(network, forKey: .network)
        try container.encode(security, forKey: .security)
        if network == "raw" { try container.encode(rawSettings, forKey: .rawSettings) }
        if network == "ws" { try container.encode(wsSettings, forKey: .wsSettings) }
        if network == "httpupgrade" { try container.encode(httpUpgradeSettings, forKey: .httpUpgradeSettings) }
        if security == "tls" { try container.encode(tlsSettings, forKey: .tlsSettings) }
        if security == "reality" { try container.encode(realitySettings, forKey: .realitySettings) }
    }
}

/// Raw stream settings.
@frozen public struct RawSettings: Codable {
    public init(from decoder: any Decoder) throws {}
    public init () {}
}

/// Reality protocol settings.
@MemberwiseInit(.public)
@frozen public struct RealitySetting: Codable {
    public var show: Bool = false
    public var target: String = ""
    public var xver: Int = 0
    public var serverNames: [String] = []
    public var privateKey: String = ""
    public var minClientVer: String = ""
    public var maxClientVer: String = ""
    public var shortIds: [String] = []
    public var fingerprint: String = ""
    public var serverName: String = ""
    public var publicKey: String = ""
    public var shortId: String = ""
    public var spiderX: String = ""
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.show = try container.decode(Bool.self, forKey: .show)
        self.target = try container.decode(String.self, forKey: .target)
        self.xver = try container.decode(Int.self, forKey: .xver)
        self.serverNames = try container.decode([String].self, forKey: .serverNames)
        self.privateKey = try container.decode(String.self, forKey: .privateKey)
        self.minClientVer = try container.decode(String.self, forKey: .minClientVer)
        self.maxClientVer = try container.decode(String.self, forKey: .maxClientVer)
        self.shortIds = try container.decode([String].self, forKey: .shortIds)
        self.fingerprint = try container.decode(String.self, forKey: .fingerprint)
        self.serverName = try container.decode(String.self, forKey: .serverName)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.shortId = try container.decode(String.self, forKey: .shortId)
        self.spiderX = try container.decode(String.self, forKey: .spiderX)
    }
    public init(){}
}

/// TLS settings for streams.
@MemberwiseInit(.public)
@frozen public struct TLSSettings: Codable {
    public var serverName: String = ""
    public var rejectUnknownSni: Bool = false
    public var allowInsecure: Bool = false
    public var alpn: [String] = []
    public var minVersion: String = ""
    public var maxVersion: String = ""
    public var cipherSuites: String = ""
    public var certificates: [String] = []
    public var disableSystemRoot: Bool = false
    public var enableSessionResumption: Bool = false
    public var fingerprint: String = ""
    public var pinnedPeerCertificateChainSha256: [String] = []
    public var curvePreferences: [String] = []
    public var masterKeyLog: String = ""
    private enum CodingKeys: String, CodingKey {
        case serverName, allowInsecure, alpn, fingerprint
    }
    public init(){}
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serverName = try container.decodeIfPresent(String.self, forKey: .serverName) ?? ""
        self.allowInsecure = try container.decodeIfPresent(Bool.self, forKey: .allowInsecure) ?? false
        self.alpn = try container.decodeIfPresent([String].self, forKey: .alpn) ?? []
        self.fingerprint = try container.decodeIfPresent(String.self, forKey: .fingerprint) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !alpn.isEmpty { try container.encode(alpn, forKey: .alpn) }
        if !serverName.isEmpty { try container.encode(serverName, forKey: .serverName) }
        if !fingerprint.isEmpty { try container.encode(fingerprint, forKey: .fingerprint) }
        if allowInsecure { try container.encode(allowInsecure, forKey: .allowInsecure) }
    }
}

/// WebSocket stream settings.
@MemberwiseInit(.public)
@frozen public struct WebSocketSettings: Codable {
    public var acceptProxyProtocol: Bool? = false
    public var path: String = ""
    public var host: String = ""
    public var headers: [String: String]? = [:]
    public var heartbeatPeriod: Int? = 10
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.acceptProxyProtocol = try container.decodeIfPresent(Bool.self, forKey: .acceptProxyProtocol)
        self.path = try container.decode(String.self, forKey: .path)
        self.host = try container.decode(String.self, forKey: .host)
        self.headers = try container.decodeIfPresent([String : String].self, forKey: .headers)
        self.heartbeatPeriod = try container.decodeIfPresent(Int.self, forKey: .heartbeatPeriod)
    }
    public init(){}
}

/// HTTP upgrade stream settings.
@MemberwiseInit(.public)
@frozen public struct HTTPUpgradeSettings: Codable {
    public var acceptProxyProtocol: Bool = false
    public var path: String = ""
    public var host: String = ""
    public var headers: [String: String] = [:]
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.acceptProxyProtocol = try container.decode(Bool.self, forKey: .acceptProxyProtocol)
        self.path = try container.decode(String.self, forKey: .path)
        self.host = try container.decode(String.self, forKey: .host)
        self.headers = try container.decode([String : String].self, forKey: .headers)
    }
    public init(){}
}

/// Multiplexing settings for streams.
@MemberwiseInit(.public)
@frozen public struct MuxSettings {
    public var enable: Bool = false
    public var concurrency: Int = 8
    public var xudpConcurrency: Int = 16
    public var xudpProxyUDP443: String = "reject"
}

extension Config: FileDocument {
  public static var readableContentTypes = [UTType.json]
    
  public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            self = Config()
            return
        }
        self = try JSONDecoder().decode(Config.self, from: data)
    }
    
  public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}

extension Config {
    func toJSONString() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let json = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(
                codingPath: [],
                debugDescription: "Failed to convert JSON data to string"
            ))
        }
        return json
    }
}

@frozen public struct CC1: Codable {
    var outbounds: [Outbound]
}

extension Config {
    func shareLinks() throws -> [String] {
        let config = try toJSONString()
//        let res = XrayConvertXrayJsonToShareLinks(config)
//        return res.split(separator: "\n").map(String.init)
      return []
    }
    
    static func parseShareLinks(_ content: String) throws -> [Outbound] {
//        let res = XrayConvertShareLinksToXrayJson(content)
//        let config = try JSONDecoder().decode(CC1.self, from: res.data(using: .utf8)!)
        return []
    }
    
    mutating func importLinks(_ content: String) throws {
        let outbounds = try Config.parseShareLinks(content)
        self.outbounds.append(contentsOf: outbounds)
    }
}

extension Config {
    func writeConfig() {
        let config = try! toJSONString()
        try? config.write(to: Common.configPath, atomically: true, encoding: .utf8)
    }
    mutating func enableMetrics() {
        // print("enableMetrics")
        self.stats = Stats()
        self.metrics = Metrics()
        // policy
        self.policy = self.policy ?? Policy()
        self.policy?.system = PolicySystem.enableAll
        // create dokodemo-door inbound
        var inbound = Inbound.dokodemo
        inbound.tag = "metrics-api"
        if !self.inbounds.contains(where: { $0.tag == inbound.tag }) {
            self.inbounds.append(inbound)
        }
        
        // creare rule
        var rule = Rule()
        rule.ruleTag = "metrics-rule"
        rule.inboundTag = [inbound.tag]
        rule.outboundTag = metrics!.tag
        if !self.routing.rules.contains(where: { $0.ruleTag ==  rule.ruleTag}) {
            self.routing.rules.append(rule)
        }
    }
    mutating func disableMetrics() {
        let rule = routing.rules.first { $0.outboundTag == self.metrics?.tag }
        inbounds.removeAll(where: { rule?.inboundTag.contains($0.tag) ??  false })
        routing.rules.removeAll(where: { $0.outboundTag == self.metrics?.tag })
        stats = nil
        metrics = nil
        policy?.system = nil
    }
    func findSocksProxy() -> Inbound? {
        return self.inbounds.first { $0.protocol == "socks" }
    }
    func findMetricsPort() -> Int? {
        let rule = routing.rules.first { $0.outboundTag == self.metrics?.tag }
        return self.inbounds.first { rule?.inboundTag.contains($0.tag) ?? false }?.port
    }
}
