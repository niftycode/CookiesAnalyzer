//
//  DetailViewController.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 15/05/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Cocoa


class DetailViewController: NSViewController {
    
    // IB outlets
    @IBOutlet weak var tableView: NSTableView!
    
    // Properties
    let cellheight:CGFloat = 33
    var cookiesData: [BrowserCookies]!
    var browserFlag: Int? {
        didSet {
            updateUI()
        }
    }
    
    /**
     Update the user interface when the user switches to another browser. A browser flag indicates the chosen browser. In this view is only a reload of the table view necessary.
     - version: 0.1
     - date: August 22nd, 2016
     */
    func updateUI() {
        if (isViewLoaded) {
            if (browserFlag != nil) {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.setDelegate(self)
        // tableView.setDataSource(self)
        
        tableView.reloadData()
    }
    
    override func viewWillAppear() {
        // The user may switch between the 'overview' and the 'detailview',
        // so for this case the table view should be reloaded to display the 
        // correct cookies.
        tableView.reloadData()
    }
    
    // MARK - TableView Labels
    
    func makeLabel(txt:String,
                           _ width:CGFloat,
                             _ align:NSTextAlignment = .left)
        -> NSTextField
    {
        let label = NSTextField(frame: CGRect(x: 0, y: 0, width: width, height: cellheight))
        
        label.stringValue = txt
        label.isEditable = false
        label.isBezeled = false
        label.drawsBackground = false
        label.alignment = align
        
        return label
    }
    
    func makeDateLabel(txt:String,
                               _ width:CGFloat,
                                 _ align:NSTextAlignment = .left)
        -> NSTextField
    {
        let label = NSTextField(frame: CGRect(x: 0, y: 0, width: width, height: cellheight))
        
        if (txt.characters.count) == 13 {
            
            let date = (Int(txt))!
            
            // Convert epoch time to a human readable date and time.
            let humanReadableDate = NSDate(jsonDate: "/Date(\(date))/")!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .medium
            
            label.stringValue = dateFormatter.string(from: humanReadableDate as Date)
            label.isEditable = false
            label.isBezeled = false
            label.drawsBackground = false
            
        } else {
            
            let epoch = String(txt.characters.dropLast(3))
            let date = Int(epoch) ?? 0
            let humanReadableDate = NSDate(jsonDate: "/Date(\(date))/")!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .medium
            
            label.stringValue = dateFormatter.string(from: humanReadableDate as Date)
            label.isEditable = false
            label.isBezeled = false
            label.drawsBackground = false
            
        }
        return label
    }
}

extension DetailViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if let cookiesData = cookiesData {
            return cookiesData.count
        } else {
            print("ERROR: No Data available!")
            return 0
        }
    }
    
    // Method for View-based TableViews
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                                      row: Int) -> NSView?
    {
        if let columnId = tableColumn?.identifier {
            let width = tableColumn!.width
            switch columnId {
            case let x where x.rawValue == "baseDomain":
                return makeLabel(txt: cookiesData[row].baseDomain, width)
            case let x where x.rawValue == "creationTime":
                return makeDateLabel(txt: cookiesData[row].creationTime, width)
            default:
                break
            }
        }
        return nil
    }
    
    // rows not selectable
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}
