//
//  ContainerViewController.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 15/05/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController {
    
    // IB Outlets
    @IBOutlet weak var browserNameLabel: NSTextField!
    @IBOutlet weak var firefoxButton: NSButton!
    @IBOutlet weak var safariButton: NSButton!
    @IBOutlet weak var chromeButton: NSButton!
    
    // Properties
    var readSafariCookies = ReadSafariCookies()
    fileprivate var overviewViewController: OverviewController!
    fileprivate var detailViewController: DetailViewController!
    var myData: [BrowserCookies]?
    var cookiesInDatabase: Int?
    var browserFlag: Int = 1
    var systemDefaultBrowser: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBrowserAvailability()
        
        let defaultBrowser = DefaultBrowser()
        
        // check for the default browser
        systemDefaultBrowser = defaultBrowser.readLaunchServices()
        // print("default browser: \(String(describing: systemDefaultBrowser))")
        
        setupDefaultBrowser()
    }
    
    /**
     Check the available browser.
     - version: 0.1
     - date: March 18th, 2017
     */
    func setupBrowserAvailability() {
        
        let availableBrowser = AvailableBrowser()
        let browserAvailability = availableBrowser.checkBrowser()
        
        if (browserAvailability == (0, 0, 0)) {
            self.browserWarningAlert()
        }        
        
        if (browserAvailability.0 == 0) {
            firefoxButton.isEnabled = false
        } else {
            // self.updateFirefoxCookies()
        }
        if (browserAvailability.1 == 0) {
            safariButton.isEnabled = false
        } else {
            // self.updateSafariCookies()
            
        }
        if (browserAvailability.2 == 0) {
            chromeButton.isEnabled = false
        } else {
            // call chrome setup ...
        }
    }
    
    func updateChromeCookies() {
        myData = ReadChromeCookies.readChromeCookiesFromSqlite()
        cookiesInDatabase = myData?.count
    }
    
    func updateFirefoxCookies() {
        myData = ReadFirefoxCookies.readFromSqlite()
        cookiesInDatabase = myData?.count
    }
    
    func updateSafariCookies() {
        myData = readSafariCookies.readFromBinaryFile()
        cookiesInDatabase = myData?.count
    }
    
    private func setupDefaultBrowser() {
        
        if (systemDefaultBrowser == "Chrome") {
            browserNameLabel.stringValue = "Chrome Browser"
            updateChromeCookies()
        } else if (systemDefaultBrowser == "Firefox") {
            browserNameLabel.stringValue = "Firefox Browser"
            updateFirefoxCookies()
        } else if (systemDefaultBrowser == "Safari") {
            browserNameLabel.stringValue = "Safari Browser"
            updateSafariCookies()
        } else {
            browserNameLabel.stringValue = "Unknown Browser!"
            print("Error: Unknown Browser!")
            // TODO: Create a NSAlert
        }
    }
    
    // Show alert window
    private func browserWarningAlert() {
        
        let alert = NSAlert()
        // alert.icon =
        alert.messageText = "Warning"
        alert.addButton(withTitle: "Ok")
        alert.informativeText = "No Data available. Do you have any Browser installed?"
        alert.runModal()
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        let tabViewController = segue.destinationController as! NSTabViewController
        
        for controller in tabViewController.childViewControllers {
            
            if controller is OverviewController {
                overviewViewController = controller as! OverviewController
                overviewViewController.browserFlag = browserFlag
                overviewViewController.cookiesInDatabase = cookiesInDatabase!
                overviewViewController.myData = myData
            } else {
                detailViewController = controller as! DetailViewController
                detailViewController.cookiesData = myData
            }
        }
    }
    
    /*
    // Terminate this app when closing the window
    override func viewDidDisappear() {
        super.viewDidDisappear()
        NSApplication.shared().terminate(self)
    }
    */
    
    // MARK: - IB actions
    
    @IBAction func selectFirefoxBrowser(_ sender: NSButton) {
        browserNameLabel.stringValue = "Firefox Browser"
        browserFlag =  0
        updateFirefoxCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
    
    @IBAction func selectSafariBrowser(_ sender: NSButton) {
        browserNameLabel.stringValue = "Safari Browser"
        browserFlag = 1
        updateSafariCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
    
    @IBAction func selectChromeBrowser(_ sender: NSButton) {
        browserNameLabel.stringValue = "Chrome Browser"
        browserFlag = 2
        updateChromeCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
    
    @IBAction func updateCookies(_ sender: NSButton) {
        
        print("invoke updateCookies using responder chain")
    }
}
