//
//  OverviewController.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 15/05/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Cocoa

class OverviewController: NSViewController {
    
    // IB outlets
    @IBOutlet weak var countLabel: NSTextField!
    @IBOutlet weak var newCookiesLabel: NSTextField!
    @IBOutlet weak var mostCookiesTableView: NSTableView!
    
    // Properties
    let startValuesManager = StartValuesManager()
    var readSafariCookies = ReadSafariCookies()
    var mostCookies = [MostCookies]()
    var findMostCookies = FindMostCookies()
    var myData: [BrowserCookies]?
    var cookiesInDatabase: Int = 0
    
    var browserFlag: Int? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countLabel.stringValue = String(cookiesInDatabase)
        
        updateUI()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    /**
    Calculate new Cookes since last analysis and save the actual cookies amount.
    - version: 0.3
    - date: August 22nd, 2016
    */
    private func checkCookiesAmount() {
        
        // actual amount of cookies in the chosen browser's database
        let actualCookies = myData!.count
        
        if (browserFlag == 0) {
            let previousFirefoxCookies = startValuesManager.previousFirefoxCookies
            let newFirefoxCookies = actualCookies - previousFirefoxCookies
            startValuesManager.previousFirefoxCookies = actualCookies
            newCookiesLabel.stringValue = String(newFirefoxCookies)
        } else if (browserFlag == 1) {
            let previousSafariCookies = startValuesManager.previousSafariCookies
            let newSafariCookies = actualCookies - previousSafariCookies
            startValuesManager.previousSafariCookies = actualCookies
            newCookiesLabel.stringValue = String(newSafariCookies)
        } else if (browserFlag == 2) {
            let previousChromeCookies = startValuesManager.previousChromeCookies
            let newChromeCookies = actualCookies - previousChromeCookies
            startValuesManager.previousChromeCookies = actualCookies
            newCookiesLabel.stringValue = String(newChromeCookies)
        } else {
            print("Error: Unknown browser!")
        }
    }
    
    /**
     Determine the five most Cookies in the chosen browser's database.
     - version: 0.1
     - date: August 22nd, 2016
     */
    private func getMostCookies() {
        mostCookies = findMostCookies.getMostCookies(cookiesInDatabase: myData!)
    }
    
    /**
     Update the user interface when the user switches to another browser. A browser flag indicates the chosen browser.
     - version: 0.1
     - date: August 22nd, 2016
     */
    private func updateUI() {
        if (isViewLoaded) {
            if (browserFlag != nil) {
                self.checkCookiesAmount()
                self.getMostCookies()
                countLabel.stringValue = String(cookiesInDatabase)
                mostCookiesTableView.reloadData()
            }
        }
    }
    
    // Show alert window
    private func warningAlert() {
        
        let alert = NSAlert()
        // alert.icon =
        alert.messageText = "Information"
        alert.addButton(withTitle: "Ok")
        alert.informativeText = "Functionality not yet implemented!"
        alert.runModal()
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func startAnalyzing(_ sender: NSButton) {
        self.warningAlert()
        /*
        myData = MozillaCookies.readFromSqlite()
        self.checkFiveMostCookies()
        mostCookiesTableView.reloadData()
        
        if (myData.isEmpty) {
            self.warningAlert()
        } else {
            countLabel.stringValue = String(myData.count)
            self.checkCookiesAmount()
        }
        */
    }
    
    
    
}

extension OverviewController: NSTableViewDataSource, NSTableViewDelegate {
    
    // data source method
    func numberOfRows(in tableView: NSTableView) -> Int {
        return mostCookies.count
    }
    
    // delegate method
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var domainName: String = ""
        var cellIdentifier: String = ""
        
        let item = mostCookies[row]
        
        domainName = item.domainName
        cellIdentifier = "domainNameCell"
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = domainName
            return cell
        }
        return nil
    }
    
}
