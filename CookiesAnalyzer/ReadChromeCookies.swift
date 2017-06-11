//
//  ReadChromeCookies.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 03.05.17.
//  Copyright © 2017 Bodo Schönfeld. All rights reserved.
//

import Foundation
import GRDB

class ReadChromeCookies {
    
    /**
     Read Chrome Cookies from the SQLite database.
     - version: 0.1
     - returns: The Cookies from the Chrome Browser.
     */
    static func readChromeCookiesFromSqlite() -> [BrowserCookies] {
        
        var sqliteData = [BrowserCookies]()
        
        // Search for the correct file path
        let chromeCookiesPath = ChromeCookiesPath()
        var chromeCookiesFilePath = ""
        
        do {
            chromeCookiesFilePath = try chromeCookiesPath.createChromeCookiesPath()
        } catch _ {
            chromeCookiesFilePath = "noFilePath"
        }
        
        if (chromeCookiesFilePath != "noFilePath") {
            
            var dbQueue: DatabaseQueue!
            
            // Get data from the database
            do {
                dbQueue = try DatabaseQueue(path: chromeCookiesFilePath)
            } catch _ {
                print("error creating database queue")
            }
            
            var domainArray = [String]()
            var creationTimeArray = [String]()
            
            var cookiesCount: Int!
            
            do {
                cookiesCount = try dbQueue.inDatabase { db in
                    try Int.fetchOne(db, "SELECT COUNT(*) FROM cookies")!
                }
            } catch _ {
                print("Error: Can't count cookies in database!")
            }
            
            do {
                try dbQueue.inDatabase { db in
                    
                    let rows = try Row.fetchCursor(db, "SELECT * FROM cookies")
                    
                    while let row = try rows.next() {
                        let title: String = row.value(named: "host_key")
                        domainArray.append(title)
                    }
                }
            } catch _ {
                print("Error: Cannot read database!")
            }
            
            do {
                try dbQueue.inDatabase { db in
                    
                    let rows = try Row.fetchCursor(db, "SELECT * FROM cookies")
                    
                    while let row = try rows.next() {
                        let creationTime: String = row.value(named: "creation_utc")
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
                    
                    sqliteData.append(BrowserCookies(baseDomain: a, creationTime: b))
                    
                    n+=1
                    
                } while n < cookiesCount
            }
        }
        return sqliteData
    }
}
