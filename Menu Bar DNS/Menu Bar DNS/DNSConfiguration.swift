//
//  DNSConfiguration.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 12/01/2021.
//

import Cocoa
import SystemConfiguration

class DNSConfiguration: NSObject {
    
    static let DNSConfigurationTypeKey = "com.dns-menubar-app.dns"
    static let ServiceTypeWiFi         = "IEEE80211"
    static let ServiceTypeEthernet     = "Ethernet"
    
    static func getnterfaceTypeByServiceIDs(_ services: Array<SCNetworkService>) throws -> Dictionary<String, String> {
        let allServicesIDsAndInterfaceType = try services.map { service -> (String, String) in
            guard
                let id = SCNetworkServiceGetServiceID(service) as String?,
                let interface = SCNetworkServiceGetInterface(service),
                let interfaceType = SCNetworkInterfaceGetInterfaceType(interface) as String?
            else {
                throw SCCopyLastError()
            }
            return (id, interfaceType)
        }
        return Dictionary(uniqueKeysWithValues: allServicesIDsAndInterfaceType)
    }
    
    static func isConnectedService(_ service : SCNetworkService) throws -> Bool {
        
        guard
            let id = SCNetworkServiceGetServiceID(service) as String?
        else {
            throw SCCopyLastError()
        }
        
        let dynmaicStore =  SCDynamicStoreCreate(kCFAllocatorSystemDefault, "DNSSETTING" as CFString, nil, nil)
        let serviceStateIPv4Key = "State:/Network/Service/\(id)/IPv4" as CFString
        let value = SCDynamicStoreCopyValue(dynmaicStore, serviceStateIPv4Key) as CFPropertyList?
        return value !=  nil
    }
    
    static func getDNSForServiceID(_ serviceID:String) -> [String] {
        let serviceDNSKey = "State:/Network/Service/\(serviceID)/DNS" as CFString
        let serviceSetupDNSKey = "Setup:/Network/Service/\(serviceID)/DNS" as CFString
        let dynmaicStore =  SCDynamicStoreCreate(kCFAllocatorSystemDefault, "DNSSETTING" as CFString, nil, nil)
        
        let dynamicPlist = SCDynamicStoreCopyValue(dynmaicStore, serviceDNSKey)
        let manualAddressPlist = SCDynamicStoreCopyValue(dynmaicStore, serviceSetupDNSKey)
        
        if let dnsValues = dynamicPlist?[kSCPropNetDNSServerAddresses] as? [String] {
            return dnsValues
        }
        
        if let manualDNS = manualAddressPlist?[kSCPropNetDNSServerAddresses] as? [String] {
            return manualDNS
        }
        return []
    }
    
    static func getAddresses()  -> (Array<String>, Array<String>) {
        var ethernetDNSAddresses : Array<String> = []
        var WiFiDNSAddresses : Array<String> = []
        
        do {
            
            let prefs = SCPreferencesCreate(
                nil, DNSConfigurationTypeKey as NSString,
                nil
            ) as SCPreferences?
            let allServicesCF = SCNetworkServiceCopyAll(prefs!)
            let allServices = allServicesCF as? [SCNetworkService]
            
            let allConnectedServices = try allServices?.filter({ (service) -> Bool in
                return try isConnectedService(service)
            })
            let serviceTypeByIDs = try getnterfaceTypeByServiceIDs(allConnectedServices!) as Dictionary<String, String>?
            for (id, type) in serviceTypeByIDs! {
                switch (type) {
                case  ServiceTypeWiFi:
                    WiFiDNSAddresses += getDNSForServiceID(id)
                case ServiceTypeEthernet:
                    ethernetDNSAddresses += getDNSForServiceID(id)
                default:
                    print("")
                }
            }
        }
        catch {
            return ([], [])
        }
        return (ethernetDNSAddresses, WiFiDNSAddresses)
    }
    
}
