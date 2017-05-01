//
//  FirefoxCookiesPath.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 17/03/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

private let firefoxIniFile = "/profiles.ini"
private let cookiesFile = "/cookies.sqlite"

class FirefoxCookiesPath {
    
    /**
     Determine the path to the Firefox cookies file.
     - version: 0.1
     - returns: The URL string to the Firefox cookies file.
     */
    func createFirefoxCookiesPath() throws -> String {
        
        let prefix = "Path"
        var profileDirectoryName = ""
        
        // Get the home directory path
        let homeDirectory = NSURL(fileURLWithPath: NSHomeDirectory())
        
        // Create path to the firefox directory
        let libraryPath = "Library/Application Support/Firefox/"
        let l = homeDirectory.appendingPathComponent(libraryPath)
        let libraryPathString: String = l!.path
        
        // Create path to the profiles.ini
        let profilesString = libraryPathString.appendingFormat(firefoxIniFile)
        
        let iniFileText = try NSString(contentsOfFile: profilesString, encoding: String.Encoding.utf8.rawValue)
        
        // Check the name of the user's profile directory
        iniFileText.enumerateLines({ (line, stop) -> () in
            if (line.hasPrefix(prefix)) {
                profileDirectoryName = String(line.characters.dropFirst(14))
            }
        })
        
        // Create complete path to cookies database
        let cookiesPath = libraryPathString + "/Profiles/" + profileDirectoryName + cookiesFile
        
        return cookiesPath

    }
}
