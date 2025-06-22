import Foundation.NSCoder
import MemberwiseInit

/// Represents a DNS server configuration.
@frozen public struct DNSServer: Codable {
    /// The address of the DNS server.
    var address: String = ""
    /// The port of the DNS server.
    var port: Int = 53
    /// The list of domains served by this DNS server.
    var domains: [String] = []
    /// The expected IPs for this server.
    var expectIPs: [String]?
    /// Whether to skip fallback for this server.
    var skipFallback: Bool?
    /// The client IP to use for queries.
    var clientIP: String?
}

/// The type of DNS server, either simple (address string) or full (DNSServer struct).
public enum DNSServerType: Codable {
    /// A simple DNS server represented by an address string.
    case simple(String)
    /// A full DNS server configuration.
    case full(DNSServer)
    
    public enum CodingKeys: String, CodingKey {
        case type, server
    }
    
    /// Encodes the DNS server type to an encoder.
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
    
    /// Decodes the DNS server type from a decoder.
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

/// Represents a host mapping for DNS, either a direct address or multiple addresses.
public enum HostMapping: Codable {
    /// A direct mapping to a single address.
    case direct(String)
    /// A mapping to multiple addresses.
    case multiple([String])
    
    /// Encodes the host mapping to an encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .direct(let address):
            try container.encode(address)
        case .multiple(let addresses):
            try container.encode(addresses)
        }
    }
    
    /// Decodes the host mapping from a decoder.
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
@MemberwiseInit(.public)
@frozen public struct DNS: Codable {
    /// The tag for this DNS configuration.
    public var tag: String = ""
    /// The query strategy for DNS resolution.
    public var queryStrategy: String = ""
    /// The list of DNS servers.
    public var servers: [DNSServerType] = []
    /// The host mappings for DNS.
    public var hosts: [String: HostMapping] = [:]
    /// The client IP for DNS queries.
    public var clientIP: String?
    /// Whether to disable DNS cache.
    public var disableCache: Bool?
    /// Whether to disable DNS fallback.
    public var disableFallback: Bool?
    /// Whether to disable fallback if a match is found.
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
