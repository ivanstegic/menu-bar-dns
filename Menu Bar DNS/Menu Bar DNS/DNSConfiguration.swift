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
        var allDNSIPAddresses : Array<String> = []
        
        let dynamicPlist = SCDynamicStoreCopyValue(dynmaicStore, serviceDNSKey)
        let manualAddressPlist = SCDynamicStoreCopyValue(dynmaicStore, serviceSetupDNSKey)
        
        if let dnsValues = manualAddressPlist?[kSCPropNetDNSServerAddresses] as? [String] {
            return dnsValues
        }
        
        if let dhcpValues = dynamicPlist?[kSCPropNetDNSServerAddresses] as? [String] {
            let uniqueValues = Array(Set(dhcpValues))
            for dhcpValue in uniqueValues {
                let newvalue = dhcpValue.appending(" (via DHCP)")
                allDNSIPAddresses.append(newvalue)
            }
        }
        return allDNSIPAddresses
    }
    
    static func saveAddress(interface serviceID: String, ipAddresses dnsServers: [String]) -> (Bool, String){
        
        let prefs = SCPreferencesCreate(
            nil, DNSConfigurationTypeKey as NSString,
            nil
        ) as SCPreferences?
        let allServicesCF = SCNetworkServiceCopyAll(prefs!)
        let allServices = allServicesCF as? [SCNetworkService]
        
        let ourService = allServices?.filter({ (service) -> Bool in
            guard let id = SCNetworkServiceGetServiceID(service) as String?  else { return false }
            return id == serviceID
        })
        let dictionary = [
            kSCPropNetDNSServerAddresses: dnsServers,
        ] as [CFString : Any]
        
        if ourService!.count > 0 {
            let networkProtocol = SCNetworkServiceCopyProtocol(ourService![0], kSCNetworkProtocolTypeDNS)
            
            SCPreferencesLock(prefs!, true)
            if !SCNetworkProtocolSetConfiguration(networkProtocol!, dictionary as CFDictionary) {
                return (false, String.init(cString: SCErrorString(SCError())))
            }
            SCPreferencesUnlock(prefs!)
            if !SCPreferencesCommitChanges(prefs!) {
                return (false, String.init(cString: SCErrorString(SCError())))
            }
            if !SCPreferencesApplyChanges(prefs!) {
                return (false, String.init(cString: SCErrorString(SCError())))
            }
            return (true, "")
        }
        return (false, "Unknown Network Service!")
    }
    
    static func getAddresses()  -> (Array<NetworkInterface>) {
        var networkInterfaces : Array<NetworkInterface> = []
        
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
                var DNSIPAddresses : Array<String>
                var serviceType : NetworkServiceType
                
                switch (type) {
                case ServiceTypeWiFi:
                    DNSIPAddresses = getDNSForServiceID(id)
                    serviceType = .WiFI
                    
                case ServiceTypeEthernet:
                    DNSIPAddresses = getDNSForServiceID(id)
                    serviceType = .Ethernet
                default:
                    DNSIPAddresses = []
                    serviceType = .Unknown
                }
                
                if serviceType != .Unknown {
                    networkInterfaces.append(NetworkInterface(serviceID: id, dnsIPAddreses: DNSIPAddresses, serviceType: serviceType))
                }
            }
        }
        catch {
            print("error while fetching dns addresses")
        }
        return networkInterfaces
    }
    
}
