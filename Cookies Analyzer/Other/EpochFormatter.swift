//
//  EpochFormatter.swift
//  CookiesAnalyzer
//
//  Extension by Brian Coleman 
//  from http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
//

import Foundation

extension NSDate {
    convenience init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = Scanner(string: jsonDate)
        
        // Check prefix:
        if scanner.scanString(prefix, into: nil) {
            
            // Read milliseconds part:
            var milliseconds: Int64 = 0
            var timeStamp: TimeInterval = 0.0
            
            if scanner.scanInt64(&milliseconds) {
                
                if String(milliseconds).len > 13 {
                    // epoch Chrome
                    timeStamp = (TimeInterval(milliseconds)/1000.0)-11644473600
                } else {
                    // epoch Firefox and Safari
                    timeStamp = (TimeInterval(milliseconds)/1000.0)
                }
                
                // Read optional timezone part:
                var timeZoneOffset: Int = 0
                if scanner.scanInt(&timeZoneOffset) {
                    let hours = timeZoneOffset / 100
                    let minutes = timeZoneOffset % 100
                    // Adjust timestamp according to timezone:
                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                }
                
                // Check suffix:
                if scanner.scanString(suffix, into: nil) {
                    // Success! Create NSDate and return.
                    self.init(timeIntervalSince1970: timeStamp)
                    return
                }
            }
        }
        // Wrong format, return nil. (The compiler requires us to
        // do an initialization first.)
        self.init(timeIntervalSince1970: 0)
        return nil
    }
}
