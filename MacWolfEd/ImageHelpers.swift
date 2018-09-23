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

import AppKit
import CommonSwift
import Foundation

///
/// Converts a paletted raw image to RGBA
///
private func palettedToRGBA(data: Data) -> Data {
    var out = Data()
    for byte in data {
        let colour = palette[Int(byte)]
        out.append(255)
        out.append(colour.blue)
        out.append(colour.green)
        out.append(colour.red)
    }
    return out
}

///
/// CGImage extensions
///
extension CGImage {

    ///
    /// From raw paletted data
    /// https://stackoverflow.com/a/36175362
    ///
    static func fromRawPaletted(data: Data, width: Int) throws -> CGImage {
        let height = data.count / width
        let rgba = palettedToRGBA(data: data)
        let render = CGColorRenderingIntent.defaultIntent
        let info = CGBitmapInfo.byteOrder32Little
        guard
            let provider = CGDataProvider(data: NSData(data: rgba)),
            let cgimage = CGImage(width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bitsPerPixel: 32,
                                  bytesPerRow: width * 4,
                                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                  bitmapInfo: info,
                                  provider: provider,
                                  decode: nil,
                                  shouldInterpolate: true,
                                  intent: render) else
        {
            throw MyError.outOfMemory
        }
        return cgimage
    }
}
