//
//  AppDelegate.swift
//  Menu Bar DNS
//
//  Created by Akshay Phulare on 04/01/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        let itemImage = NSImage(named: "barcode-box-fill")
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        
        statusItem?.button?.action = #selector(self.statusBarButtonClicked(sender:))

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //MARK: - status bar action
    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        NSApplication.shared.terminate(self)
    }


}

