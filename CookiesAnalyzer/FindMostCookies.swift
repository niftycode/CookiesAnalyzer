//
//  FindMostCookies.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 19/08/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

class FindMostCookies {
    
    private var mostCookiesArray = [MostCookies]()
    
    /**
     Find the five most cookies in the database.
     - version: 0.3
     - date: August 26th, 2016
     - parameters: 
        - cookiesInDatabase: The actual cookies in the database of the chosen browser.
     - returns: The most cookies in the database.
     */
    func getMostCookies(cookiesInDatabase: [BrowserCookies]) -> [MostCookies] {
        
        mostCookiesArray.removeAll()
        
        var baseDomains = [String]()
        for i in cookiesInDatabase {
            baseDomains.append(i.baseDomain)
        }
        
        // dictionary for the baseDomains
        var counts = [String: Int]()
        
        for baseDomain in baseDomains {
            counts[baseDomain] = (counts[baseDomain] ?? 0) + 1
        }
        
        // Notice: It might be a better idea to check if there are really five
        // key-value-pairs in the 'counts' Dictionary? May be in later version?
        var z = 0
        
        repeat {
            
            var max = 0
            if let m = counts.values.max() {
                max = m
            } else {
                print("ERROR: Found nil while unwrapping the 'counts' Dictionary!")
            }
            
            for (domain, amount) in counts {
                if amount == max {
                    mostCookiesArray.append(MostCookies(domainName: domain))
                    // remove "most cookie" from dictionary
                    counts.removeValue(forKey: domain)
                }
            }
            z += 1
            
        } while z < 3
        
        return mostCookiesArray
    }
}
