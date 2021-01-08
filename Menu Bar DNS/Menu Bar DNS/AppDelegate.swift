//
//  AppDelegate.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 04/01/2021.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        let itemImage = NSImage(named: "menubar-icon")
        statusItem?.button?.image = itemImage
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(didClickMenubar)
        
    }
    
    @objc func didClickMenubar() {
        NSApp.terminate(self)
    }

}

