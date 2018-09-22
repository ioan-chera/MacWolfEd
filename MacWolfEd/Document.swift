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

class Document: NSDocument {

    @IBOutlet var mapDropDown: NSPopUpButton!
    @IBOutlet var mapView: MapView!
    @IBOutlet var nextLevelChooser: NSButton!
    @IBOutlet var previousLevelChooser: NSButton!

    //
    // The level set used by this document
    //
    private var levelSet: LevelSet? {
        didSet {
            updateViews()
        }
    }

    //
    // Updates the display views
    //
    func updateViews() {
        if mapView == nil {
            return  // quit if nib not loaded yet
        }

        // Update map drop down
        mapDropDown.removeAllItems()
        if let levels = levelSet?.levels {
            for level in levels {
                if let level = level {
                    mapDropDown.addItem(withTitle: level.name)
                    let item = mapDropDown.item(at: mapDropDown.numberOfItems - 1)
                    item?.action = #selector(Document.levelChooserClicked(_:))
                    item?.target = self
                    item?.representedObject = level
                }
            }
        }
        levelChooserClicked(mapDropDown.selectedItem)
    }

    ///
    /// When level chooser was clicked
    ///
    @objc func levelChooserClicked(_ sender: AnyObject?) {
        mapView.level = sender?.representedObject as? Level
    }

    ///
    /// When going to previous level
    ///
    @IBAction func goToPreviousLevel(_ sender: AnyObject?) {
        if mapDropDown.indexOfSelectedItem == 0 {
            NSSound.beep()
            return
        }
        mapDropDown.selectItem(at: mapDropDown.indexOfSelectedItem - 1)
        levelChooserClicked(mapDropDown.selectedItem)
    }

    @IBAction func goToNextLevel(_ sender: AnyObject?) {
        if mapDropDown.indexOfSelectedItem >= mapDropDown.numberOfItems - 1 {
            NSSound.beep()
            return
        }
        mapDropDown.selectItem(at: mapDropDown.indexOfSelectedItem + 1)
        levelChooserClicked(mapDropDown.selectedItem)
    }

    //
    // Enable and disable menu items
    //
    override func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        if item.action == #selector(Document.goToPreviousLevel(_:)) {
            return mapDropDown.indexOfSelectedItem > 0
        }
        if item.action == #selector(Document.goToNextLevel(_:)) {
            return mapDropDown.indexOfSelectedItem < mapDropDown.numberOfItems - 1
        }
        return super.validateUserInterfaceItem(item)
    }

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        updateViews()
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    //
    // Read from a given URL
    //
    override func read(from url: URL, ofType typeName: String) throws {
        levelSet = try LevelSet(folder: url)
    }
}
