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
/// Loads VSWAP files
///
class VSwapContainer {
    private(set) var pages: [Data]

    ///
    /// Initializer
    ///
    init(file: URL) throws {
        let data = try Data(contentsOf: file)
        let reader = DataReader(data: data)

        let numChunks = try reader.readUInt16()
        let spriteStart = try reader.readUInt16()
        let soundStart = try reader.readUInt16()
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
                throw DataReaderError.readError
            }
        }

        var alignPadding = 0
        for u in spriteStart ..< soundStart {
            let offset = pageOffsets[Int(u)]
            if offset == 0 {
                continue
            }
            let offs = Int(offset) - Int(dataStart) + alignPadding
            if offs & 1 == 1 {
                alignPadding += 1
            }
        }

        pages = []
        for u in 0 ..< numChunks {
            let offset = pageOffsets[Int(u)]
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
            pages.append(try reader.readData(length: size))
        }
    }
}
