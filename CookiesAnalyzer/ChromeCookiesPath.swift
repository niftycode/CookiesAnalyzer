//
//  ChromeCookiesPath.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 01.05.17.
//  Copyright © 2017 Bodo Schönfeld. All rights reserved.
//

import Foundation
import Cocoa

class ChromeCookiesPath {
    
    /**
     Determine the path of Chrome's cookies file.
     - version: 0.1
     - returns: The URL string to the Chrome cookies file.
     */
    func createChromeCookiesPath() throws -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let cookiesPath = "Library/Application Support/Google/Chrome/Default/Cookies"
        let cookiesUrl = home.appendingPathComponent(cookiesPath)
        
        var urlString = ""
        
        do {
            urlString = try String(contentsOf: cookiesUrl)
        } catch _ {
            print("bad url")
        }
        
        return urlString
    }
}
