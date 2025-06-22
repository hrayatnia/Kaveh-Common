import Foundation.NSCoder
import MemberwiseInit

// DNS Server configuration
@frozen public struct DNSServer: Codable {
    var address: String = ""
    var port: Int = 53
    var domains: [String] = []
    var expectIPs: [String]?
    var skipFallback: Bool?
    var clientIP: String?
}

// DNS Server type enum
public enum DNSServerType: Codable {
    case simple(String)
    case full(DNSServer)
    
    public enum CodingKeys: String, CodingKey {
        case type, server
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .simple(let address):
            var container = encoder.singleValueContainer()
            try container.encode(address)
        case .full(let server):
            var container = encoder.singleValueContainer()
            try container.encode(server)
        }
    }
    
    public init(from decoder: Decoder) throws {
        if let address = try? decoder.singleValueContainer().decode(String.self) {
            self = .simple(address)
            return
        }
        
        if let server = try? decoder.singleValueContainer().decode(DNSServer.self) {
            self = .full(server)
            return
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Invalid DNS server format"
            )
        )
    }
}

// Host mapping type enum
public enum HostMapping: Codable {
    case direct(String)
    case multiple([String])
    
  public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .direct(let address):
            try container.encode(address)
        case .multiple(let addresses):
            try container.encode(addresses)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let singleAddress = try? container.decode(String.self) {
            self = .direct(singleAddress)
        } else if let multipleAddresses = try? container.decode([String].self) {
            self = .multiple(multipleAddresses)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid host mapping format"
                )
            )
        }
    }
}

/// Main DNS configuration for the application.
@MemberwiseInit
@frozen public struct DNS: Codable {
    public var tag: String = ""
    public var queryStrategy: String = ""
    public var servers: [DNSServerType] = []
    public var hosts: [String: HostMapping] = [:]
    public var clientIP: String?
    public var disableCache: Bool?
    public var disableFallback: Bool?
    public var disableFallbackIfMatch: Bool?
    
    enum CodingKeys: String, CodingKey {
        case servers, hosts, clientIP, queryStrategy
        case disableCache, disableFallback
        case disableFallbackIfMatch, tag
    }
}

public extension DNS {
  public static var demo: DNS {
        var dns = DNS()
        dns.tag = "dns-server"
        dns.servers = [
            .simple("114.114.114.114"),
            .simple("8.8.8.8")
        ]
        return dns
    }
}
