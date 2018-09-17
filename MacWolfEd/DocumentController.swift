/*
 MacWolfEd: Wolf3D editor for Mac
 Copyright (C) 2018  Ioan Chera

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

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
