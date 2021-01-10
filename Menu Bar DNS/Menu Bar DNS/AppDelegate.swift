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
        statusItem?.menu = menu
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

