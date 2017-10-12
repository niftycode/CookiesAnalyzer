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
        
        // check browser availability
        setupBrowserAvailability()
        
        // check for the default browser
        let defaultBrowser = DefaultBrowser()
        systemDefaultBrowser = defaultBrowser.readLaunchServices()
        
        setupDefaultBrowser()
    }
    
    override func viewDidAppear() {
        
        // Invoke methods in WindowController
        /*
        if let windowController = view.window?.windowController as? WindowController {
            windowController.checkBrowserAvailability()
        }
         */
    }
    
    /**
     Check which browser button has been clicked
     - version: 0.1
     - date: August 5th, 2017
     */
    /*
    @IBAction func browserButtonClicked(_ sender: NSView) {
        
        print("Button klicked!")
        
    }
    */
    
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
            updateChromeCookies()
        } else if (systemDefaultBrowser == "Firefox") {
            defaultBrowserLabel.stringValue = "Firefox Browser"
            updateFirefoxCookies()
        } else if (systemDefaultBrowser == "Safari") {
            defaultBrowserLabel.stringValue = "Safari Browser"
            updateSafariCookies()
        } else {
            defaultBrowserLabel.stringValue = "Unknown Browser!"
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
    
    // MARK: - IB actions
    
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
    
    @IBAction func updateCookies(_ sender: NSButton) {
        
        switch browserFlag {
        case 0:
            updateFirefoxCookies()
        case 1:
            updateSafariCookies()
        case 2:
            updateChromeCookies()
        default:
            print("no browser available")
        }
    }
}
