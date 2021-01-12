//
//  AppDelegate.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 04/01/2021.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem?.button?.image = statusItemImage()
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(didClickMenubar)
    }
    
    func rebuildMenuWithAddress(_ ethernetDNSAddresses:[String], _ wifiDNSAddresses:[String]) {
        
        var dnsAdded = false
        menu?.removeAllItems()
        
        if ethernetDNSAddresses.count > 0  {
            menu?.addItemWithTitle(title: "Ethernet",
                                   action: nil,
                                   keyEquivalent: "",
                                   boldFont: true)
            menu?.addItemFromList(list: ethernetDNSAddresses,
                                  action: nil,
                                  keyEquivalent: "",
                                  prefix: "  ")
            dnsAdded = true
        }
        
        if wifiDNSAddresses.count > 0 {
            menu?.addItemWithTitle(title: "WiFi",
                                   action: nil,
                                   keyEquivalent: "",
                                   boldFont: true)
            menu?.addItemFromList(list: wifiDNSAddresses,
                                  action: nil,
                                  keyEquivalent: "",
                                  prefix: "  ")
            
            dnsAdded = true
        }
        
        if !dnsAdded {
            menu?.addItem(withTitle: "Disconnected", action: nil, keyEquivalent: "")
        }
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(withTitle: "Help", action:  #selector(didClickMenuHelp), keyEquivalent: "")
        menu?.addItem(withTitle: "Quit Menu Bar DNS", action:  #selector(didClickMenuQuitMenuBarDNS), keyEquivalent: "")
    }
    
    @objc func didClickMenubar() {
        let dnsAddresses = DNSConfiguration.getAddresses()
        let ethernetAddresses = dnsAddresses.0
        let wifiAddresses = dnsAddresses.1
        
        rebuildMenuWithAddress(ethernetAddresses, wifiAddresses)
        statusItem?.menu = menu
        statusItem?.button?.performClick(self)
        statusItem?.menu = nil
    }
    
    func statusItemImage() -> NSImage? {
        let image:NSImage? = NSImage(named: NSImage.Name("menubar-icon"))
        image?.isTemplate = true
        return image;
    }
    
    @IBAction func didClickMenuHelp(_ sender: Any) {
        let  url: URL? = URL.init(string: "https://ivanstegic.com/menu-bar-dns/")
        NSWorkspace.shared.open(url!)
    }
    
    @IBAction func didClickMenuQuitMenuBarDNS(_ sender: Any) {
        NSApp.terminate(self)
    }
}

