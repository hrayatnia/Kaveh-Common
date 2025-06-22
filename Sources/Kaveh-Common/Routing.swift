import SwiftUI
import MemberwiseInit

/// Routing rule for traffic.
@MemberwiseInit(.public)
@frozen public struct Rule: Hashable, Codable, Equatable {
    public var type: String = "field"
    public var ruleTag: String = ""
    public var domainMatcher: String = ""
    public var domain: [String] = []
    public var ip: [String] = []
    public var port: String = ""
    public var sourcePort: String = ""
    public var source: [String] = []
    public var user: [String] = []
    public var inboundTag: [String] = []
    public var `protocol`: [String] = []
    public var attrs: [String: String] = [:]
    public var outboundTag: String = ""
    public var balancerTag: String = ""
    public var network: String = ""
    
    public var networks: [String] {
        get {
            return self.network.split(separator: ",").map(String.init)
        }
        set {
            self.network = newValue.joined(separator: ",")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case domainMatcher, type, domain, ip, port
        case sourcePort, source, user, inboundTag
        case `protocol`, attrs, outboundTag, balancerTag
        case ruleTag, network
    }
    public init(){}
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "field"
        ruleTag = try container.decodeIfPresent(String.self, forKey: .ruleTag) ?? ""
        network = try container.decodeIfPresent(String.self, forKey: .network) ?? ""
        domainMatcher = try container.decodeIfPresent(String.self, forKey: .domainMatcher) ?? ""
        domain = try container.decodeIfPresent([String].self, forKey: .domain) ?? []
        source = try container.decodeIfPresent([String].self, forKey: .source) ?? []
        sourcePort = try container.decodeIfPresent(String.self, forKey: .sourcePort) ?? ""
        ip = try container.decodeIfPresent([String].self, forKey: .ip) ?? []
        port = try container.decodeIfPresent(String.self, forKey: .port) ?? ""
        user = try container.decodeIfPresent([String].self, forKey: .user) ?? []
        `protocol` = try container.decodeIfPresent([String].self, forKey: .protocol) ?? []
        attrs = try container.decodeIfPresent([String: String].self, forKey: .attrs) ?? [:]
        inboundTag = try container.decodeIfPresent([String].self, forKey: .inboundTag) ?? []
        outboundTag = try container.decodeIfPresent(String.self, forKey: .outboundTag) ?? ""
        balancerTag = try container.decodeIfPresent(String.self, forKey: .balancerTag) ?? ""
    }
  public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(ruleTag, forKey: .ruleTag)
        if !domainMatcher.isEmpty {
            try container.encode(domainMatcher, forKey: .domainMatcher)
        }
        if !domain.isEmpty {
            try container.encode(domain, forKey: .domain)
        }
        if !ip.isEmpty {
            try container.encode(ip, forKey: .ip)
        }
        if !port.isEmpty {
            try container.encode(port, forKey: .port)
        }
        if !sourcePort.isEmpty {
            try container.encode(sourcePort, forKey: .sourcePort)
        }
        if !source.isEmpty {
            try container.encode(source, forKey: .source)
        }
        if !user.isEmpty {
            try container.encode(user, forKey: .user)
        }
        if !`protocol`.isEmpty {
            try container.encode(`protocol`, forKey: .protocol)
        }
        if !attrs.isEmpty {
            try container.encode(attrs, forKey: .attrs)
        }
        if !inboundTag.isEmpty {
            try container.encode(inboundTag, forKey: .inboundTag)
        }
        if !outboundTag.isEmpty {
            try container.encode(outboundTag, forKey: .outboundTag)
        }
        if !balancerTag.isEmpty {
            try container.encode(balancerTag, forKey: .balancerTag)
        }
        if !network.isEmpty {
            try container.encode(network, forKey: .network)
        }
    }
    public static var china_ip_direct: Rule {
        var rule = Rule()
        rule.ruleTag = "china-ip-direct"
        rule.ip = ["geoip:cn"]
        rule.outboundTag = "direct"
        return rule
    }
    public static var china_domain_direct: Rule {
        var rule = Rule()
        rule.ruleTag = "china-domain-direct"
        rule.domain = ["geosite:cn"]
        rule.outboundTag = "direct"
        return rule
    }
    public static var match_all: Rule {
        var rule = Rule()
        rule.ruleTag = "match-all"
        rule.port = "1-65535"
        rule.outboundTag = "proxy"
        rule.balancerTag = "proxy"
        return rule
    }
}

/// Routing configuration for the application.
@MemberwiseInit(.public)
@frozen public struct Routing: Codable {
    public var domainStrategy: String = "AsIs"
    public var domainMatcher: String = "hybrid"
    public var balancers: [Balancer] = []
    public var rules: [Rule] = [
        Rule.china_ip_direct,
        Rule.china_domain_direct,
        Rule.match_all
    ]
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.domainStrategy = try container
      .decode(String.self, forKey: .domainStrategy)
    self.domainMatcher = try container
      .decode(String.self, forKey: .domainMatcher)
    self.balancers = try container.decode([Balancer].self, forKey: .balancers)
    self.rules = try container.decode([Rule].self, forKey: .rules)
  }
  public init(){}
}

/// Balancer configuration for routing.
@MemberwiseInit(.public)
@frozen public struct Balancer: Codable {
    public var tag: String = ""
    public var selector: [String] = []
    public var fallbackTag: String = ""
    public var strategy: BalancerStrategy = BalancerStrategy()
    
    public static var proxy: Balancer {
        return Balancer(
            tag: "proxy",
            selector: ["^((?!direct|block).)*$"],
            fallbackTag: "direct"
        )
    }
}

/// Strategy for a balancer.
@MemberwiseInit(.public)
@frozen public struct BalancerStrategy: Codable {
    public var type: String = ""
    public var settings: BalancerStrategySettings?
  
  public init(){}
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decode(String.self, forKey: .type)
    self.settings = try container
      .decodeIfPresent(BalancerStrategySettings.self, forKey: .settings)
  }
}

/// Settings for a balancer strategy.
@MemberwiseInit(.public)
@frozen public struct BalancerStrategySettings: Codable {
    public var expected: Int = 2
    public var maxRTT: String = ""
    public var tolerance: Double = 0.01
    public var baselines: [String] = ["1s"]
    public var costs: [CostObject] = []
}

/// Cost object for routing decisions.
@MemberwiseInit(.public)
@frozen public struct CostObject: Codable {
    public var regexp: Bool = false
    public var match: String = ""
    public var value: Double = 0.5
}
