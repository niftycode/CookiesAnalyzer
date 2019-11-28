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
        
        // TODO: Check if Firefox is open
        
        if (firefoxCookiesFilePath != "noFilePath") {
            
            // Get data from the database
            let dbQueue = try! DatabaseQueue(path: firefoxCookiesFilePath)
            
            var domainArray = [String]()
            var lastAccessedArray = [String]()
            var creationTimeArray = [String]()
            
            let cookiesCount = try! dbQueue.inDatabase { db in
                try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM moz_cookies")!
            }
            
            
            do {
                try dbQueue.inDatabase { db in
                    
                    let rows = try Row.fetchCursor(db, sql: "SELECT * FROM moz_cookies")
                    
                    while let row = try rows.next() {
                        let title: String = row["baseDomain"]
                        domainArray.append(title)
                    }
                }
            } catch _ {
                print("Error: Cannot read database!")
            }
            
            do {
                try dbQueue.inDatabase { db in
                    
                    let rows = try Row.fetchCursor(db, sql: "SELECT * FROM moz_cookies")
                    
                    while let row = try rows.next() {
                        let lastAccessedTime: String = row["lastAccessed"]
                        lastAccessedArray.append(lastAccessedTime)
                    }
                }
            } catch _ {
                print("Error: Cannot read database!")
            }
            
            do {
                try dbQueue.inDatabase { db in
                    
                    let rows = try Row.fetchCursor(db, sql: "SELECT * FROM moz_cookies")
                    
                    while let row = try rows.next() {
                        let creationTime: String = row["creationTime"]
                        creationTimeArray.append(creationTime)
                    }
                }
            } catch _ {
                print("Error: Cannot read database!")
            }
            
            var n = 0
            
            if (!domainArray.isEmpty) {
                
                repeat {
                    
                    let a = domainArray[n]
                    let b = creationTimeArray[n]
                    //let b = lastAccessedArray[n] // no longer used
                    
                    // sqliteData.append(MozillaCookies(baseDomain: a, lastAccessed: b, creationTime: c))
                    
                    sqliteData.append(BrowserCookies(baseDomain: a, creationTime: b))
                    
                    n+=1
                    
                } while n < cookiesCount
                
            }
        }
        return sqliteData
    }
}
