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
    static func readChromeCookiesFromSqlite() {
        
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
            
            // Get data from the database
            do {
                let dbQueue = try DatabaseQueue(path: chromeCookiesFilePath)
            } catch _ {
                print("error creating database queue")
            }
            
            var domainArray = [String]()
            var creationTimeArray = [String]()
            
        }
        
    }
    
    
}
