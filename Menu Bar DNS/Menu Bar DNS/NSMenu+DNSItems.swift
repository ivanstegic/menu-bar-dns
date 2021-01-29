//
//  NSMenu+DNSItems.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 12/01/2021.
//

import Cocoa

extension NSMenu {
    func addItemWithTitle(title string: String, action selector: Selector?, keyEquivalent charCode: String, boldFont makeFontBold: Bool) {
        let newMenuItem = NSMenuItem(title: string, action: selector, keyEquivalent: charCode)
        
        if makeFontBold {
            let font = NSFont.menuFont(ofSize: 0)
            let fontManger = NSFontManager.shared as NSFontManager
            let boldFont = fontManger.convert(font, toHaveTrait: .boldFontMask)
            newMenuItem.attributedTitle = NSAttributedString(string: string,
                                                              attributes: [NSAttributedString.Key.font: boldFont])
        }
        self.addItem(newMenuItem)
    }
    
    func updateDNSConfigViewFrame() {
        for item in self.items {
            if let view = item.view {
                view.setFrameSize(NSMakeSize(self.size.width, NSHeight(view.frame)))
                view.needsLayout = true
            }
        }
    }
   
    func insertIPAddressesFromInterface(interface item: NetworkInterface,  atIndex index: Int) {
        
        let itemTitle = item.dnsIPAddreses[0]
            let menuItem = NSMenuItem.init(title: "\(itemTitle)",
                                           action: nil,
                                           keyEquivalent: "")
            menuItem.state = .on
            self.insertItem(menuItem, at: index)
            let board = NSStoryboard(name: "Main", bundle: nil)
            let dnsConfigViewController = board.instantiateController(withIdentifier: "DNSConfigurationView")
                      as! NSViewController
            let menuView = dnsConfigViewController.view as! DNSConfigurationView
            menuView.setViewForInterface(item, itemTitle)
            menuItem.view = dnsConfigViewController.view
    }
    
    func addIPAddressesFromInterface(interface item: NetworkInterface,  action selector: Selector?, keyEquivalent charCode: String) {
        
        for itemTitle in item.dnsIPAddreses {
            let menuItem = NSMenuItem.init(title: "\(itemTitle)",
                                           action: selector,
                                           keyEquivalent: charCode)
            menuItem.state = .on
            self.addItem(menuItem)
            let board = NSStoryboard(name: "Main", bundle: nil)
            let dnsConfigViewController = board.instantiateController(withIdentifier: "DNSConfigurationView")
                      as! NSViewController
            let menuView = dnsConfigViewController.view as! DNSConfigurationView
            menuView.setViewForInterface(item, itemTitle)
            menuItem.view = dnsConfigViewController.view
        }
    }
}
