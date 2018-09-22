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

    private(set) var levels: [Level?]

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
        let rlewTag = try headReader.readUInt16()
        let headerOffsets = try headReader.readInt32Array(count: numMaps)

        //
        // Loads a map
        //
        func loadMap(header: LevelHeader, mapReader: DataReader) throws -> Level? {
            var mapSegs = [[UInt16](), [UInt16]()]
            for plane in stride(from: 0, to: mapPlanes, by: 1) {
                let pos = header.planeStart[plane]
                let compressed = header.planeLength[plane]
                try mapReader.seek(position: Int(pos))
                var source = try mapReader.readData(length: Int(compressed))
                let expanded = try DataReader(data: source).readUInt16()
                source.removeSubrange(0..<2)
                let buffer2seg = try Compress.carmackExpand(source: source, length: Int(expanded))
                mapSegs[plane] = Compress.rlewExpand(source: Array(buffer2seg.suffix(from: 1)),
                                                     length: mapArea * 2, tag: rlewTag)
                // Check size
                if mapSegs[plane].count != mapArea {    // sanity check
                    // TODO: report error to user
                    print("Invalid mapseg count of \(header.name) plane \(plane): \(mapSegs[plane].count)")
                    return nil
                }
            }

            return Level(walls: mapSegs[0], actors: mapSegs[1], name: header.name)
        }

        let mapReader = DataReader(data: gamemaps)
        levels = [Level?]()
        for offset in headerOffsets {
            if offset < 0 {
                levels.append(nil)
                continue
            }
            try mapReader.seek(position: Int(offset))
            let header = LevelHeader(planeStart: try mapReader.readInt32Array(count: 3),
                                     planeLength: try mapReader.readUInt16Array(count: 3),
                                     width: try mapReader.readUInt16(),
                                     height: try mapReader.readUInt16(),
                                     name: try mapReader.readCString(length: 16))

            levels.append(try loadMap(header: header, mapReader: mapReader))
        }
    }
}
