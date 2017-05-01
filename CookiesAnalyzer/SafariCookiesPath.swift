//
//  SafariCookiesPath.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 19/08/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

class SafariCookiesPath {
    
    /** 
     Creates Safari's cookies path.
     - version: 0.1
     - returns: The URL string to the Safari cookies file.
     */
    func createSafariCookiesPath() throws -> String {
        
        // The name of Safari's cookies file
        let cookiesFile = "/Cookies.binarycookies"
        
        // get the home directory path
        let homeDirectory = NSURL(fileURLWithPath: NSHomeDirectory())
        
        // create path to the Safari directory
        let libraryPath = "Library/Cookies/"
        let l = homeDirectory.appendingPathComponent(libraryPath)
        let libraryPathString: String = l!.path
        
        // create complete path to cookies database
        let cookiesPath = libraryPathString + cookiesFile
        
        return cookiesPath
    }
}
