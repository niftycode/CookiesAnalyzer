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
    
    static func createCookiesUrl() -> URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let cookiesPath = "Library/Application Support/Google/Chrome/Default/Cookies"
        let cookiesUrl = home.appendingPathComponent(cookiesPath)
        return cookiesUrl
    }
    
}
