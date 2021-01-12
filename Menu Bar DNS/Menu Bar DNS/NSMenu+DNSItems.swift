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
    
    func addItemFromList(list items: [String],  action selector: Selector?, keyEquivalent charCode: String, prefix string:String) {
        
        for itemTitle in items {
            self.addItem(NSMenuItem.init(title: "\(string)\(itemTitle)",
                                         action: selector,
                                         keyEquivalent: charCode))
        }
    }
}
