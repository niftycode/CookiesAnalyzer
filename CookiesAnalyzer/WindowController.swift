//
//  WindowController.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 15.06.17.
//  Copyright © 2017 Bodo Schönfeld. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    // IB outlets
    @IBOutlet weak var firefoxBrowser: NSButton!
    @IBOutlet weak var safariBrowser: NSButton!
    @IBOutlet weak var chromeBrowser: NSButton!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // print(firefoxBrowser.tag)
    }
    
    /**
     Check the available browser.
     - version: 0.1
     - date: June 15th, 2017
     */
    func checkBrowserAvailability() {
        
        // Not in use...
        
        let availableBrowser = AvailableBrowser()
        let browserAvailability = availableBrowser.checkBrowser()
        
        if (browserAvailability == (0, 0, 0)) {
            //self.browserWarningAlert()
        }
        
        if (browserAvailability.0 == 0) {
            firefoxBrowser.isEnabled = false
        }
        
        if (browserAvailability.1 == 0) {
            safariBrowser.isEnabled = false
        }
        
        if (browserAvailability.2 == 0) {
            chromeBrowser.isEnabled = false
        }
    }
}
