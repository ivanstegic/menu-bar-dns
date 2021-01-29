//
//  NetworkInterface.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 27/01/2021.
//

import Cocoa

enum NetworkServiceType {
    case WiFI
    case Ethernet
    case Unknown
}
// hold DNS erver IPs for a network service
struct NetworkInterface {
    var serviceID : String
    var dnsIPAddreses : [String]
    var serviceType : NetworkServiceType
}
