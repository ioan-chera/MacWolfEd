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

import CommonSwift
import Foundation

//
// Error handling
//
enum LevelSetError: Error {
    case missingFiles
}

//
// Header about level info
//
struct LevelHeader {
    let planeStart: [Int32]     // invariably 3 elements
    let planeLength: [UInt16]   // same here
    let width: UInt16
    let height: UInt16
    let name: String
}

//
// Wolf3D level set
//
class LevelSet {

    private let rlewTag: UInt16

    //
    // Load levels from folder
    //
    init(folder: URL) throws {
        let files = try Path.findSubpaths(url: folder, fileNames: ["gamemaps.wl6", "maphead.wl6"])

        guard let gamemapsURL = files["gamemaps.wl6"], let mapheadURL = files["maphead.wl6"] else {
            throw LevelSetError.missingFiles
        }

        // TODO: support Spear of Destiny too

        let maphead = try Data(contentsOf: mapheadURL)
        let gamemaps = try Data(contentsOf: gamemapsURL)

        let headReader = DataReader(data: maphead)
        rlewTag = try headReader.readUInt16()
        let headerOffsets = try headReader.readInt32Array(count: numMaps)

        let mapReader = DataReader(data: gamemaps)
        var headers = [LevelHeader?]()
        for offset in headerOffsets {
            if offset < 0 {
                headers.append(nil)
                continue
            }
            try mapReader.seek(position: Int(offset))
            headers.append(LevelHeader(planeStart: try mapReader.readInt32Array(count: 3),
                                       planeLength: try mapReader.readUInt16Array(count: 3),
                                       width: try mapReader.readUInt16(),
                                       height: try mapReader.readUInt16(),
                                       name: try mapReader.readCString(length: 16)))

            // TODO: load each map
        }
    }
}
