# CookiesAnalyzer

## About

This is a little just-for-fun-project. The app reads the cookies.sqlite file from the *Firefox Browser*, the Cookies.binarycookies file from the *Safari Browser* and the Cookies SQLite file from the *Chrome Browser*. After successfully reading these files the domains with the corresponding creation time will be shown in a table view.

To fetch the sqlite data it's using the [GRDB.swift toolkit](https://github.com/groue/GRDB.swift). 

## Things To Do

* ~~Add app icon~~
* ~~Add Safari Browser~~
* ~~Add Firefox Browser~~
* ~~Add Chrome Browser~~
* Add Vivaldi Browser
* ~~Update epoch time converter~~
* Unit Tests
* UI Tests
* Edit Menu Bar
* Sort Cookies TableView
* Mark new Cookies in the Cookies TableView

## Changelog

* April 4th, 2016: Added error handling.
* May 15th, 2016: Added TabView Controller
* August 21st, 2016: Added Safari support
* August 26th, 2016: Fixed 'most-cookies-bug' 
* June 7th, 2017: Added Chrome support
* December 21st, 2017: Updated GRDB.swift
* April 19th, 2018: Updated to Swift 4.1

## Requirements

* Xcode 9.x
* OS X 10.13
* [GRDB.swift](https://github.com/groue/GRDB.swift)

## References

* [GRDB.swift](https://github.com/groue/GRDB.swift)
* [NSViewController Class Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSViewController_Class/)

