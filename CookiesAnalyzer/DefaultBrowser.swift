//
//  DefaultBrowser.swift
//  CookiesAnalyzer_OSX
//
//  Created by Bodo Schönfeld on 18/03/2017.
//  Copyright © 2017 Bodo Schönfeld. All rights reserved.
//

import Foundation


class DefaultBrowser {
    
    
    /**
     Creates the path to the LaunchServices plist file.
     - version: 0.1
     - date: March 18th, 2017
     - returns: The URL string to the Safari cookies file.
     */
    fileprivate func createLaunchServicesPath() throws -> String {
        
        // path: ~/Library/Preferences/com.apple.LaunchServices
        
        // The name of Launch Services plist file
        let launchServicesFile = "/com.apple.launchservices.secure.plist"
        
        // get the home directory path
        let homeDirectory = NSURL(fileURLWithPath: NSHomeDirectory())
        
        // create path to the Library Preferences folder
        let libraryPath = "Library/Preferences/com.apple.LaunchServices"
        let l = homeDirectory.appendingPathComponent(libraryPath)
        let libraryPathString: String = l!.path
        
        // create complete path to launch services
        let launchServicesPath = libraryPathString + launchServicesFile
        
        return launchServicesPath
    }
    
    /**
     Read data from the LaunchServices plist file
     - version: 0.1
     - date: March 18th, 2017
     - returns: The system's default browser.
     */
    func readLaunchServices() -> String {
        
        var launchServicesFilePath = ""
        var launchServicesDictionary: NSDictionary?
        
        do {
            launchServicesFilePath = try createLaunchServicesPath()
        } catch _ {
            launchServicesFilePath = "noFilePath"
        }
        
        var httpDictionary: Dictionary<String , Any>?
        
        if (launchServicesFilePath != "noFilePath") {
            
            launchServicesDictionary = NSDictionary(contentsOfFile: launchServicesFilePath)
            
            if let d = launchServicesDictionary {
                
                let itemsArray: NSArray = d.object(forKey: "LSHandlers") as! NSArray
                
                for i in 0 ..< itemsArray.count {
                    
                    var item: Dictionary = itemsArray.object(at: i) as! [String: Any]
                    
                    if let dictValues = item["LSHandlerURLScheme"] as? String {
                        if (dictValues == "http") {
                            httpDictionary = itemsArray[i] as? Dictionary
                        }
                    }
                }
            }
        }
        
        var browser: String = ""
        if let dictValue = httpDictionary?["LSHandlerRoleAll"] as? String{
            
            // (P) What about other browser apps?
            if (dictValue == "com.apple.safari") {
                browser = "Safari"
            } else if (dictValue == "com.google.chrome") {
                browser = "Chrome"
            } else {
                browser = "Firefox"
            }
            
        }
        return browser
    }
    
}
