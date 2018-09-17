//
//  AppDelegate.swift
//  MacWolfEd
//
//  Created by ioan on 16.09.2018.
//  Copyright © 2018 Ioan Chera. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //
    // Setup the document controller
    //
    func applicationWillFinishLaunching(_ notification: Notification) {
        let _ = DocumentController()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

