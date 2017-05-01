//
//  ReadFirefoxCookies.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 22/08/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation
import GRDB

class ReadFirefoxCookies: NSObject {
    
    /** 
     Read Firefox Cookies from the SQLite database.
     - version: 0.1
     - returns: The Cookies from the Firefox Browser.
     */
    static func readFromSqlite() -> [BrowserCookies] {
        
        var sqliteData = [BrowserCookies]()
        
        // Search for the correct file path
        let firefoxCookiesPath = FirefoxCookiesPath()
        var firefoxCookiesFilePath = ""
        
        do {
            firefoxCookiesFilePath = try firefoxCookiesPath.createFirefoxCookiesPath()
        } catch _ {
            firefoxCookiesFilePath = "noFilePath"
        }
        
        if (firefoxCookiesFilePath != "noFilePath") {
            
            // Get data from the database
            // let dbQueue = try DatabaseQueue(path: "/path/to/database.sqlite")
            let dbQueue = try! DatabaseQueue(path: firefoxCookiesFilePath)
            
            var domainArray = [String]()
            var lastAccessedArray = [String]()
            var creationTimeArray = [String]()
            
            
            let cookiesCount = try! dbQueue.inDatabase { db in
                try Int.fetchOne(db, "SELECT COUNT(*) FROM moz_cookies")!
            }
            
            /*
            dbQueue.inDatabase { db in
                for row in Row.fetchCursor(db, "SELECT * FROM moz_cookies") {
                    let title: String = row.value(named: "baseDomain")
                    domainArray.append(title)
                }
            }
            */
            
            try! dbQueue.inDatabase { db in
            
                let rows = try Row.fetchCursor(db, "SELECT * FROM moz_cookies")
                
                while let row = try rows.next() {
                    let title: String = row.value(named: "baseDomain")
                    domainArray.append(title)
                }
                
            
            }
            
            /*
            dbQueue.inDatabase { db in
                for row in Row.fetchCursor(db, "SELECT * FROM moz_cookies") {
                    let lastAccessedTime: String = row.value(named: "lastAccessed")
                    lastAccessedArray.append(lastAccessedTime)
                }
            }
            */
            
            try! dbQueue.inDatabase { db in
                
                let rows = try Row.fetchCursor(db, "SELECT * FROM moz_cookies")
                
                while let row = try rows.next() {
                    let lastAccessedTime: String = row.value(named: "lastAccessed")
                    lastAccessedArray.append(lastAccessedTime)
                }
            }
            
            /*
            dbQueue.inDatabase { db in
                for row in Row.fetchCursor(db, "SELECT * FROM moz_cookies") {
                    let creationTime: String = row.value(named: "creationTime")
                    creationTimeArray.append(creationTime)
                }
            }
            */
            
            try! dbQueue.inDatabase { db in
                
                let rows = try Row.fetchCursor(db, "SELECT * FROM moz_cookies")
                
                while let row = try rows.next() {
                    let creationTime: String = row.value(named: "creationTime")
                    creationTimeArray.append(creationTime)
                }
            }
            
            
            var n = 0
            
            if (!domainArray.isEmpty) {
                
                repeat {
                    
                    let a = domainArray[n]
                    let b = creationTimeArray[n]
                    //let b = lastAccessedArray[n] // no longer used
                    
                    // sqliteData.append(MozillaCookies(baseDomain: a, lastAccessed: b, creationTime: c))
                    
                    sqliteData.append(BrowserCookies(baseDomain: a, creationTime: b))
                    
                    // n++ is deprecated
                    n+=1
                    
                } while n < cookiesCount
                
            }
        }
        return sqliteData
    }
}
