//
//  ReadSafariCookies.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 22/08/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

class ReadSafariCookies {
    
    var binaryFileData = [BrowserCookies]()
    
    /**
     This function calls BinaryCookies.parse() to read and parse the data from Safari's binary file.
     - version: 0.1
     - returns: The Array of BrowserCookies objects (from the Safari Browser).
     */
    func readFromBinaryFile() -> [BrowserCookies] {
        
        let safariCookiesPath = SafariCookiesPath()
        var safariCookiesFilePath = ""
        
        do {
            safariCookiesFilePath = try safariCookiesPath.createSafariCookiesPath()
        } catch _ {
            safariCookiesFilePath = "noFilePath"
        }
        
        if (safariCookiesFilePath != "noFilePath") {
            
            // cookiePath
            // cookieURL
            // data
            
            BinaryCookies.parse(cookiePath: safariCookiesFilePath, callback: {
                (error: BinaryCookiesError?, cookies) in
                
                // print("On the main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
                
                if let cookies = cookies {
                    self.binaryFileData = self.parseSafariCookieData(cookies: cookies)
                } else {
                    print(error ?? "default value")
                }
            })
        }
        return binaryFileData
    }
    
    /**
     Parse the [Cookies] from the binary file to get the [BrowserCookies].
     - author: Bodo Schönfeld
     - version: 0.1
     - returns: The [BrowserCookies] (with baseDomain and creationTime).
     */
    private func parseSafariCookieData(cookies: [Cookie]) -> [BrowserCookies] {
        
        var binaryFileData = [BrowserCookies]()
        var baseDomainArray = [String]()
        var creationTimeArray = [String]()
        
        for val in cookies {
            baseDomainArray.append(val.domain)
            creationTimeArray.append(String(val.creation))
        }
        
        var n = 0
        
        if (!cookies.isEmpty) {
            
            repeat {
                
                let a = baseDomainArray[n]
                let b = creationTimeArray[n]
                
                binaryFileData.append(BrowserCookies(baseDomain: a, creationTime: b))
                
                n+=1
                
            } while n < cookies.count
        }
        return binaryFileData
    }
}
