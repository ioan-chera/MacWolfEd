//
//  DocumentController.swift
//  MacWolfEd
//
//  Created by ioan on 17.09.2018.
//  Copyright © 2018 Ioan Chera. All rights reserved.
//

import Cocoa

//
// Subclass of the document controller to be able to open folders
//
class DocumentController : NSDocumentController {

    //
    // Open documents
    //
    override func beginOpenPanel(completionHandler: @escaping ([URL]?) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin { (response) in
            if response == NSApplication.ModalResponse.OK {
                completionHandler(panel.urls)
            }
        }
    }

    //
    // Allow folder
    //
    override func typeForContents(of url: URL) throws -> String {
        return "DocumentType"
    }
}
