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
    @IBOutlet weak var defaultBrowserLabel: NSTextField!
    @IBOutlet weak var selectedBrowserLabel: NSTextField!
    @IBOutlet weak var updateCookiesLabel: NSTextField!  // not connected?
    
    // Properties
    var readSafariCookies = ReadSafariCookies()
    fileprivate var overviewViewController: OverviewController!
    fileprivate var detailViewController: DetailViewController!
    var myData: [BrowserCookies]?
    var cookiesInDatabase: Int?
    var browserFlag: Int = 1
    var systemDefaultBrowser: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check browser availability
        setupBrowserAvailability()
        
        // check for the default browser
        let defaultBrowser = DefaultBrowser()
        systemDefaultBrowser = defaultBrowser.readLaunchServices()
        
        setupDefaultBrowser()
    }
    
    override func viewDidAppear() {
        
    }
    
    // MARK: - Other Methods
    
    // Show missing data alert window
    private func browserWarningAlert() {
        
        let alert = NSAlert()
        // alert.icon =
        alert.messageText = "Warning"
        alert.addButton(withTitle: "Ok")
        alert.informativeText = "No Data available. Do you have any Browser installed?"
        alert.runModal()
        
    }
    
    // Show unknown browser alert window
    private func unknownBrowserWarningAlert() {
        
        let alert = NSAlert()
        // alert.icon =
        alert.messageText = "Warning"
        alert.addButton(withTitle: "Ok")
        alert.informativeText = "Unknown browser!"
        alert.runModal()
        
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
        //myData?.removeAll()
        myData = readSafariCookies.readFromBinaryFile()
        // print(myData?.count ?? "n/a") // How many Cookies?
        cookiesInDatabase = myData?.count
    }
    
    func setupDefaultBrowser() {
        
        if (systemDefaultBrowser == "Chrome") {
            defaultBrowserLabel.stringValue = "Chrome Browser"
            selectedBrowserLabel.stringValue = "Chrome Browser"
            browserFlag = 2
            updateChromeCookies()
        } else if (systemDefaultBrowser == "Firefox") {
            defaultBrowserLabel.stringValue = "Firefox Browser"
            selectedBrowserLabel.stringValue = "Firefox Browser"
            browserFlag = 0
            updateFirefoxCookies()
        } else if (systemDefaultBrowser == "Safari") {
            defaultBrowserLabel.stringValue = "Safari Browser"
            selectedBrowserLabel.stringValue = "Safari Browser"
            browserFlag = 1
            updateSafariCookies()
        } else {
            defaultBrowserLabel.stringValue = "Unknown Browser!"
            print("Error: Unknown (default) Browser!")
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        let tabViewController = segue.destinationController as! NSTabViewController
        
        for controller in tabViewController.children {
            
            if controller is OverviewController {
                overviewViewController = controller as? OverviewController
                overviewViewController.browserFlag = browserFlag
                overviewViewController.cookiesInDatabase = cookiesInDatabase!
                overviewViewController.myData = myData
            } else {
                detailViewController = controller as? DetailViewController
                detailViewController.cookiesData = myData
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func selectFirefoxBrowser(_ sender: NSView) {
        selectedBrowserLabel.stringValue = "Firefox Browser"
        browserFlag =  0
        updateFirefoxCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
    
    @IBAction func selectSafariBrowser(_ sender: NSView) {
        selectedBrowserLabel.stringValue = "Safari Browser"
        browserFlag = 1
        updateSafariCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
    
    @IBAction func selectChromeBrowser(_ sender: NSView) {
        selectedBrowserLabel.stringValue = "Chrome Browser"
        browserFlag = 2
        updateChromeCookies()
        overviewViewController.cookiesInDatabase = cookiesInDatabase!
        overviewViewController.myData = myData
        detailViewController.cookiesData = myData
        overviewViewController.browserFlag = browserFlag
        detailViewController.browserFlag = browserFlag
    }
}
