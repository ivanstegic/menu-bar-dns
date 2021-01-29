//
//  MenuItemTextField.swift
//  Menu Bar DNS
//
//  Created by Munir Ahmed on 23/01/2021.
//

import Cocoa

class MenuItemTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
 
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.window?.makeFirstResponder(self)
        return true
    }
      
    override var canBecomeKeyView: Bool {
        return true
    }
    override func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        return true
    }
    
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        return false

    }
    
}
