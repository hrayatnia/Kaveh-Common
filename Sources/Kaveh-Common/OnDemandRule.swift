import SwiftUI
import NetworkExtension
import MemberwiseInit

/// On-demand rule for network configuration.
@MemberwiseInit(.public)
@frozen public struct OnDemandRule: Identifiable, Codable {
  public var id: UUID = UUID()
    // var name: String = ""
    public var action: RuleAction = .connect
    public var network: InterfaceType = .any
    public var ssids: [String] = []
    public var domains: [String] = []
    public var address: [String] = []
    public var probeURL: String = ""
    
    public enum RuleAction: String, Codable, CaseIterable {
        case connect
        case disconnect
        case ignore
        case evaluate
    }
    
    public enum InterfaceType: String, Codable, CaseIterable {
        case any
        case wifi
        #if os(iOS)
        case cellular
        #endif
        
        /// Returns the corresponding NEOnDemandRuleInterfaceType.
        var neInterfaceType: NEOnDemandRuleInterfaceType {
            switch self {
            case .any: return .any
            case .wifi: return .wiFi
            #if os(iOS)
            case .cellular: return .cellular
            #endif
            }
        }
    }
    
    static func fromNERule(_ rule: NEOnDemandRule) -> OnDemandRule {
        var out = OnDemandRule()
        switch rule.action {
        case .connect:
            out.action = RuleAction.connect
        case .disconnect:
            out.action = RuleAction.disconnect
        case .evaluateConnection:
            out.action = RuleAction.evaluate
        case .ignore:
            out.action = RuleAction.ignore
        @unknown default:
            fatalError("unhandled action")
        }
        switch rule.interfaceTypeMatch {
        case .any:
            out.network = .any
        case .wiFi:
            out.network = .wifi
        #if os(iOS)
        case .cellular:
            out.network = .cellular
        #endif
        @unknown default:
            fatalError("unhandled action")
        }
        out.domains = rule.dnsSearchDomainMatch ?? []
        out.address = rule.dnsServerAddressMatch ?? []
        out.ssids = rule.ssidMatch ?? []
        out.probeURL = rule.probeURL?.path ?? ""
        return out
    }
    
    func toNERule() -> NEOnDemandRule {
        let rule: NEOnDemandRule
        switch action {
        case .connect:
            rule = NEOnDemandRuleConnect()
        case .disconnect:
            rule = NEOnDemandRuleDisconnect()
        case .ignore:
            rule = NEOnDemandRuleIgnore()
        case .evaluate:
            let ruleEvaluate = NEOnDemandRuleEvaluateConnection()
            // rule1.connectionRules = []
            rule = ruleEvaluate
        }
        rule.interfaceTypeMatch = network.neInterfaceType
        if !ssids.isEmpty {
            rule.ssidMatch = ssids
        }
        if !domains.isEmpty {
            rule.dnsSearchDomainMatch = domains
        }
        if !address.isEmpty {
            rule.dnsServerAddressMatch = address
        }
        if !probeURL.isEmpty {
            rule.probeURL = URL(string: probeURL)
        }
        return rule
    }
}
