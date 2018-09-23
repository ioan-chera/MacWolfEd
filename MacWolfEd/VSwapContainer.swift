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

///
/// Wall data
///
class WallData {
    let bright: Data
    let dark: Data
    private(set) lazy var brightPic = try? makeImageFromRaw(data: bright.transposed(originalWidth: 64), width: 64)
    private(set) lazy var darkPic = try? makeImageFromRaw(data: dark.transposed(originalWidth: 64), width: 64)

    init(bright: Data, dark: Data) throws {
        self.bright = bright
        self.dark = dark
    }
}

///
/// Loads VSWAP files
///
class VSwapContainer {
    private(set) var walls: [WallData]
    private(set) var sprites: [Data]
    private(set) var soundChunks: [Data]

    ///
    /// Initializer
    ///
    init(folder: URL) throws {

        // TODO: support SPEAR and others
        let paths = try Path.findSubpaths(url: folder, fileNames: ["vswap.wl6"])
        guard let file = paths["vswap.wl6"] else {
            throw MyError.missingFiles
        }

        let data = try Data(contentsOf: file)
        let reader = DataReader(data: data)

        let numChunks = Int(try reader.readUInt16())
        let spriteStart = Int(try reader.readUInt16())
        let soundStart = Int(try reader.readUInt16())
        var pageOffsets = try reader.readUInt32Array(count: Int(numChunks) + 1)
        let pageLengths = try reader.readUInt16Array(count: Int(numChunks))

        pageOffsets[Int(numChunks)] = UInt32(data.count)
        let dataStart = pageOffsets[0]

        // Sanity checking
        for u in 0 ..< numChunks {
            let offset = pageOffsets[Int(u)]
            if offset == 0 {
                continue
            }
            if offset < dataStart || offset >= data.count {
                throw MyError.fileError
            }
        }

        func enumerate(min: Int, max: Int, action: (Data, Int) -> Void) throws {
            for u in min ..< max {
                let offset = pageOffsets[u]
                if offset == 0 {
                    continue
                }
                let size: Int
                if pageOffsets[Int(u) + 1] == 0 {
                    size = Int(pageLengths[Int(u)])
                } else {
                    size = Int(pageOffsets[Int(u) + 1]) - Int(offset)
                }
                try reader.seek(position: Int(offset))
                action(try reader.readData(length: size), u)
            }
        }

        var horizData = Data()
        walls = []
        sprites = []
        soundChunks = []

        var failed = false
        try enumerate(min: 0, max: spriteStart) { (data, index) in
            if failed {
                return
            }
            do {
                if index % 2 == 0 {
                    horizData = data
                } else {
                    walls.append(try WallData(bright: horizData, dark: data))
                }
            } catch {
                failed = true
            }
        }
        if failed {
            throw MyError.fileError
        }

        try enumerate(min: spriteStart, max: soundStart, action: { (data, index) in
            sprites.append(data)
        })

        try enumerate(min: soundStart, max: numChunks, action: { (data, index) in
            soundChunks.append(data)
        })
    }
}
