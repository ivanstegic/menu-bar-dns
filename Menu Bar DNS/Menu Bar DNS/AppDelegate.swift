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
        statusItem?.button?.image = imageForCurrentAppearance()
        statusItem?.menu = menu
        
        listenToInterfaceChangesNotification()
    }
    
    func listenToInterfaceChangesNotification() {
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(interfaceModeChanged),
            name: .AppleInterfaceThemeChangedNotification,
            object: nil
        )
    }
    
    func imageForCurrentAppearance() -> NSImage? {
        let type: String? = UserDefaults.standard.string(forKey: UserDefaultKey.AppleInterfaceStyleKey.rawValue) ?? SystemAppearance.SystemAppearanceUnspecified.rawValue
        
        if  (type == SystemAppearance.SystemAppearanceDark.rawValue) {
            return NSImage(named: "menubar-icon-dark")
        }
        return NSImage(named: "menubar-icon-light")
    }
    
    @objc func interfaceModeChanged() {
        statusItem?.button?.image = imageForCurrentAppearance()
    }
    
    @IBAction func didClickMenuHelp(_ sender: Any) {
        let  url: URL? = URL.init(string: "https://ivanstegic.com/menu-bar-dns/")
        NSWorkspace.shared.open(url!)
    }

    @IBAction func didClickMenuQuitMenuBarDNS(_ sender: Any) {
        NSApp.terminate(self)
    }
}

