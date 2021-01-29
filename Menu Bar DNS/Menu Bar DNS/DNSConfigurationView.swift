//
//  DNSConfigurationView.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 24/01/2021.
//

import Cocoa


enum Regex {
    static let ipAddress = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
}

extension String {
    var isValidIpAddress: Bool {
        return self.matches(pattern: Regex.ipAddress)
    }
    
    private func matches(pattern: String) -> Bool {
        return self.range(of: pattern,
                          options: .regularExpression,
                          range: nil,
                          locale: nil) != nil
    }
}

class DNSConfigurationView: NSView, NSTextFieldDelegate {

    @IBOutlet weak var dnsIPAddressTextField: NSTextField?
    @IBOutlet weak var dnsIPAddressLabel : NSTextField?
    @IBOutlet weak var dnsIPAddressTextFieldHeight: NSLayoutConstraint?
    @IBOutlet weak var dnsIPAddressAddValueButtonHeight: NSLayoutConstraint?
    @IBOutlet weak var dnsIPShowTextFieldButton: NSButton?
    @IBOutlet weak var dnsIPShowAddValueButton: NSButton?
    @IBOutlet weak var dnsIPServerActiveState: NSImageView?
    lazy var networkInterface : NetworkInterface = NetworkInterface(serviceID: "", dnsIPAddreses: [], serviceType: .Unknown)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        if (dnsIPShowAddValueButton?.isHidden ?? true) {
            self.dnsIPShowTextFieldButton?.isHidden = !(self.enclosingMenuItem?.isHighlighted ?? false)
        } else {
            self.dnsIPShowTextFieldButton?.isHidden = true
        }
        // Drawing code here.
    }
    
    override func awakeFromNib() {
        dnsIPAddressTextField?.delegate = self
        wantsLayer = true
      
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewDNServerAdded),
            name: NSNotification.Name("NewDNSServerAdded"),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func addNewDNSAddress(_ sender: Any) {
        
        guard let strRawTarget = dnsIPAddressTextField?.stringValue else { print("no input!"); return }
        print("Input: " + strRawTarget)
        
        dnsIPAddressTextFieldHeight?.constant = 0;
        dnsIPAddressAddValueButtonHeight?.constant = 0
        dnsIPShowAddValueButton?.isHidden = true
        dnsIPShowTextFieldButton?.isHidden = false
        invalidateIntrinsicContentSize()
        
        if strRawTarget.isValidIpAddress {
            print("\(strRawTarget) is a valid IP address")
            var newDNSServers = networkInterface.dnsIPAddreses.filter { !$0.contains("via") }
            newDNSServers.insert(strRawTarget, at: 0)
            let retValue = DNSConfiguration.saveAddress(interface: networkInterface.serviceID, ipAddresses: newDNSServers)
            let success = retValue.0
            let errorStr = retValue.1
            if !success {
                let alert: NSAlert = NSAlert()
                alert.messageText = errorStr
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            } else {
                NotificationCenter.default.post(name: Notification.Name("NewDNSServerAdded"), object: networkInterface)
               let menu = enclosingMenuItem?.menu
                networkInterface.dnsIPAddreses = newDNSServers
                menu?.insertIPAddressesFromInterface(interface: networkInterface, atIndex: menu?.index(of: enclosingMenuItem!) ?? 0)
            }
         } else {
           
            DispatchQueue.main.async {
                self.dnsIPAddressTextField?.currentEditor()?.selectedRange = NSMakeRange(strRawTarget.count, 0)
                self.dnsIPAddressTextField?.textColor = NSColor.red
            }
            print("\(strRawTarget) is not valid")
        }
    }
        
    @IBAction func showAddNewFieldAndButton(_ sender: Any) {
        dnsIPAddressTextFieldHeight?.constant = 20;
        dnsIPAddressAddValueButtonHeight?.constant = 18
        dnsIPShowAddValueButton?.isHidden = false
        dnsIPShowTextFieldButton?.isHidden = true
        invalidateIntrinsicContentSize()
    }
    
    func setViewForInterface (_ interface : NetworkInterface, _ ip : String) {
        networkInterface = interface
        dnsIPAddressLabel?.stringValue = ip
    }
 
    override var intrinsicContentSize: CGSize {
        let possibleHeight = dnsIPAddressTextFieldHeight?.constant ?? 0
        return CGSize(width: NSWidth(self.frame), height: possibleHeight + 20)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        dnsIPAddressTextField?.textColor = NSColor.controlTextColor
    }
    
    @objc func handleNewDNServerAdded(_ obj: Notification) {
        guard let interface = obj.object as? NetworkInterface else {
            print("invalid object")
            return
        }
        
        if interface.serviceID == networkInterface.serviceID {
            let dnsServerIP = dnsIPAddressLabel?.stringValue
           
            if dnsServerIP!.contains("via DHCP") {
                print("disabling \(dnsServerIP ?? "")")
                dnsIPAddressLabel?.textColor = NSColor.disabledControlTextColor
            }
        }
    }
}
