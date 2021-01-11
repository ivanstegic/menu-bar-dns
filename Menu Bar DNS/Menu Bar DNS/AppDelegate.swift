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
        
        let font = NSFont.menuFont(ofSize: 0)
        let fontManger = NSFontManager.shared as NSFontManager
        let boldFont = fontManger.convert(font, toHaveTrait: .boldFontMask)
        
        let ethernetMenuItem = NSMenuItem(title: "Ethernet", action: nil, keyEquivalent: "")
        let wifiMenuItem = NSMenuItem(title: "Ethernet", action: nil, keyEquivalent: "")

        ethernetMenuItem.attributedTitle = NSAttributedString(string: "Ethernet",
                                                              attributes: [NSAttributedString.Key.font: boldFont])
        wifiMenuItem.attributedTitle = NSAttributedString(string: "WiFi",
                                                              attributes: [NSAttributedString.Key.font: boldFont])
        
        menu?.removeAllItems()
        menu?.addItem(ethernetMenuItem)
 
        for dnsAddress in ethernetDNSAddresses {
            menu?.addItem(NSMenuItem.init(title: "  \(dnsAddress)",
                                          action: nil,
                                          keyEquivalent: ""))
        }
        menu?.addItem(wifiMenuItem)
        
        for dnsAddress in wifiDNSAddresses {
            menu?.addItem(NSMenuItem.init(title: "  \(dnsAddress)",
                                          action: nil,
                                          keyEquivalent: ""))
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

