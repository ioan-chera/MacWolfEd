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
import Foundation

///
/// Holds simple RGB information
///
struct RawColour {
    let red, green, blue: UInt8
}

///
/// Convenience to use the value from Wolf4SDL
///
private func PAL_RGB(_ r: Int, _ g: Int, _ b: Int) -> RawColour {
    return RawColour(red: UInt8(255 * Int(r) / 63),
                     green: UInt8(255 * Int(g) / 63),
                     blue: UInt8(255 * Int(b) / 63))
}

/// Wolf3D palette from Wolf4SDL
let palette = [
    PAL_RGB(  0,  0,  0),PAL_RGB(  0,  0, 42),PAL_RGB(  0, 42,  0),PAL_RGB(  0, 42, 42),PAL_RGB( 42,  0,  0),
    PAL_RGB( 42,  0, 42),PAL_RGB( 42, 21,  0),PAL_RGB( 42, 42, 42),PAL_RGB( 21, 21, 21),PAL_RGB( 21, 21, 63),
    PAL_RGB( 21, 63, 21),PAL_RGB( 21, 63, 63),PAL_RGB( 63, 21, 21),PAL_RGB( 63, 21, 63),PAL_RGB( 63, 63, 21),
    PAL_RGB( 63, 63, 63),PAL_RGB( 59, 59, 59),PAL_RGB( 55, 55, 55),PAL_RGB( 52, 52, 52),PAL_RGB( 48, 48, 48),
    PAL_RGB( 45, 45, 45),PAL_RGB( 42, 42, 42),PAL_RGB( 38, 38, 38),PAL_RGB( 35, 35, 35),PAL_RGB( 31, 31, 31),
    PAL_RGB( 28, 28, 28),PAL_RGB( 25, 25, 25),PAL_RGB( 21, 21, 21),PAL_RGB( 18, 18, 18),PAL_RGB( 14, 14, 14),
    PAL_RGB( 11, 11, 11),PAL_RGB(  8,  8,  8),PAL_RGB( 63,  0,  0),PAL_RGB( 59,  0,  0),PAL_RGB( 56,  0,  0),
    PAL_RGB( 53,  0,  0),PAL_RGB( 50,  0,  0),PAL_RGB( 47,  0,  0),PAL_RGB( 44,  0,  0),PAL_RGB( 41,  0,  0),
    PAL_RGB( 38,  0,  0),PAL_RGB( 34,  0,  0),PAL_RGB( 31,  0,  0),PAL_RGB( 28,  0,  0),PAL_RGB( 25,  0,  0),
    PAL_RGB( 22,  0,  0),PAL_RGB( 19,  0,  0),PAL_RGB( 16,  0,  0),PAL_RGB( 63, 54, 54),PAL_RGB( 63, 46, 46),
    PAL_RGB( 63, 39, 39),PAL_RGB( 63, 31, 31),PAL_RGB( 63, 23, 23),PAL_RGB( 63, 16, 16),PAL_RGB( 63,  8,  8),
    PAL_RGB( 63,  0,  0),PAL_RGB( 63, 42, 23),PAL_RGB( 63, 38, 16),PAL_RGB( 63, 34,  8),PAL_RGB( 63, 30,  0),
    PAL_RGB( 57, 27,  0),PAL_RGB( 51, 24,  0),PAL_RGB( 45, 21,  0),PAL_RGB( 39, 19,  0),PAL_RGB( 63, 63, 54),
    PAL_RGB( 63, 63, 46),PAL_RGB( 63, 63, 39),PAL_RGB( 63, 63, 31),PAL_RGB( 63, 62, 23),PAL_RGB( 63, 61, 16),
    PAL_RGB( 63, 61,  8),PAL_RGB( 63, 61,  0),PAL_RGB( 57, 54,  0),PAL_RGB( 51, 49,  0),PAL_RGB( 45, 43,  0),
    PAL_RGB( 39, 39,  0),PAL_RGB( 33, 33,  0),PAL_RGB( 28, 27,  0),PAL_RGB( 22, 21,  0),PAL_RGB( 16, 16,  0),
    PAL_RGB( 52, 63, 23),PAL_RGB( 49, 63, 16),PAL_RGB( 45, 63,  8),PAL_RGB( 40, 63,  0),PAL_RGB( 36, 57,  0),
    PAL_RGB( 32, 51,  0),PAL_RGB( 29, 45,  0),PAL_RGB( 24, 39,  0),PAL_RGB( 54, 63, 54),PAL_RGB( 47, 63, 46),
    PAL_RGB( 39, 63, 39),PAL_RGB( 32, 63, 31),PAL_RGB( 24, 63, 23),PAL_RGB( 16, 63, 16),PAL_RGB(  8, 63,  8),
    PAL_RGB(  0, 63,  0),PAL_RGB(  0, 63,  0),PAL_RGB(  0, 59,  0),PAL_RGB(  0, 56,  0),PAL_RGB(  0, 53,  0),
    PAL_RGB(  1, 50,  0),PAL_RGB(  1, 47,  0),PAL_RGB(  1, 44,  0),PAL_RGB(  1, 41,  0),PAL_RGB(  1, 38,  0),
    PAL_RGB(  1, 34,  0),PAL_RGB(  1, 31,  0),PAL_RGB(  1, 28,  0),PAL_RGB(  1, 25,  0),PAL_RGB(  1, 22,  0),
    PAL_RGB(  1, 19,  0),PAL_RGB(  1, 16,  0),PAL_RGB( 54, 63, 63),PAL_RGB( 46, 63, 63),PAL_RGB( 39, 63, 63),
    PAL_RGB( 31, 63, 62),PAL_RGB( 23, 63, 63),PAL_RGB( 16, 63, 63),PAL_RGB(  8, 63, 63),PAL_RGB(  0, 63, 63),
    PAL_RGB(  0, 57, 57),PAL_RGB(  0, 51, 51),PAL_RGB(  0, 45, 45),PAL_RGB(  0, 39, 39),PAL_RGB(  0, 33, 33),
    PAL_RGB(  0, 28, 28),PAL_RGB(  0, 22, 22),PAL_RGB(  0, 16, 16),PAL_RGB( 23, 47, 63),PAL_RGB( 16, 44, 63),
    PAL_RGB(  8, 42, 63),PAL_RGB(  0, 39, 63),PAL_RGB(  0, 35, 57),PAL_RGB(  0, 31, 51),PAL_RGB(  0, 27, 45),
    PAL_RGB(  0, 23, 39),PAL_RGB( 54, 54, 63),PAL_RGB( 46, 47, 63),PAL_RGB( 39, 39, 63),PAL_RGB( 31, 32, 63),
    PAL_RGB( 23, 24, 63),PAL_RGB( 16, 16, 63),PAL_RGB(  8,  9, 63),PAL_RGB(  0,  1, 63),PAL_RGB(  0,  0, 63),
    PAL_RGB(  0,  0, 59),PAL_RGB(  0,  0, 56),PAL_RGB(  0,  0, 53),PAL_RGB(  0,  0, 50),PAL_RGB(  0,  0, 47),
    PAL_RGB(  0,  0, 44),PAL_RGB(  0,  0, 41),PAL_RGB(  0,  0, 38),PAL_RGB(  0,  0, 34),PAL_RGB(  0,  0, 31),
    PAL_RGB(  0,  0, 28),PAL_RGB(  0,  0, 25),PAL_RGB(  0,  0, 22),PAL_RGB(  0,  0, 19),PAL_RGB(  0,  0, 16),
    PAL_RGB( 10, 10, 10),PAL_RGB( 63, 56, 13),PAL_RGB( 63, 53,  9),PAL_RGB( 63, 51,  6),PAL_RGB( 63, 48,  2),
    PAL_RGB( 63, 45,  0),PAL_RGB( 45,  8, 63),PAL_RGB( 42,  0, 63),PAL_RGB( 38,  0, 57),PAL_RGB( 32,  0, 51),
    PAL_RGB( 29,  0, 45),PAL_RGB( 24,  0, 39),PAL_RGB( 20,  0, 33),PAL_RGB( 17,  0, 28),PAL_RGB( 13,  0, 22),
    PAL_RGB( 10,  0, 16),PAL_RGB( 63, 54, 63),PAL_RGB( 63, 46, 63),PAL_RGB( 63, 39, 63),PAL_RGB( 63, 31, 63),
    PAL_RGB( 63, 23, 63),PAL_RGB( 63, 16, 63),PAL_RGB( 63,  8, 63),PAL_RGB( 63,  0, 63),PAL_RGB( 56,  0, 57),
    PAL_RGB( 50,  0, 51),PAL_RGB( 45,  0, 45),PAL_RGB( 39,  0, 39),PAL_RGB( 33,  0, 33),PAL_RGB( 27,  0, 28),
    PAL_RGB( 22,  0, 22),PAL_RGB( 16,  0, 16),PAL_RGB( 63, 58, 55),PAL_RGB( 63, 56, 52),PAL_RGB( 63, 54, 49),
    PAL_RGB( 63, 53, 47),PAL_RGB( 63, 51, 44),PAL_RGB( 63, 49, 41),PAL_RGB( 63, 47, 39),PAL_RGB( 63, 46, 36),
    PAL_RGB( 63, 44, 32),PAL_RGB( 63, 41, 28),PAL_RGB( 63, 39, 24),PAL_RGB( 60, 37, 23),PAL_RGB( 58, 35, 22),
    PAL_RGB( 55, 34, 21),PAL_RGB( 52, 32, 20),PAL_RGB( 50, 31, 19),PAL_RGB( 47, 30, 18),PAL_RGB( 45, 28, 17),
    PAL_RGB( 42, 26, 16),PAL_RGB( 40, 25, 15),PAL_RGB( 39, 24, 14),PAL_RGB( 36, 23, 13),PAL_RGB( 34, 22, 12),
    PAL_RGB( 32, 20, 11),PAL_RGB( 29, 19, 10),PAL_RGB( 27, 18,  9),PAL_RGB( 23, 16,  8),PAL_RGB( 21, 15,  7),
    PAL_RGB( 18, 14,  6),PAL_RGB( 16, 12,  6),PAL_RGB( 14, 11,  5),PAL_RGB( 10,  8,  3),PAL_RGB( 24,  0, 25),
    PAL_RGB(  0, 25, 25),PAL_RGB(  0, 24, 24),PAL_RGB(  0,  0,  7),PAL_RGB(  0,  0, 11),PAL_RGB( 12,  9,  4),
    PAL_RGB( 18,  0, 18),PAL_RGB( 20,  0, 20),PAL_RGB(  0,  0, 13),PAL_RGB(  7,  7,  7),PAL_RGB( 19, 19, 19),
    PAL_RGB( 23, 23, 23),PAL_RGB( 16, 16, 16),PAL_RGB( 12, 12, 12),PAL_RGB( 13, 13, 13),PAL_RGB( 54, 61, 61),
    PAL_RGB( 46, 58, 58),PAL_RGB( 39, 55, 55),PAL_RGB( 29, 50, 50),PAL_RGB( 18, 48, 48),PAL_RGB(  8, 45, 45),
    PAL_RGB(  8, 44, 44),PAL_RGB(  0, 41, 41),PAL_RGB(  0, 38, 38),PAL_RGB(  0, 35, 35),PAL_RGB(  0, 33, 33),
    PAL_RGB(  0, 31, 31),PAL_RGB(  0, 30, 30),PAL_RGB(  0, 29, 29),PAL_RGB(  0, 28, 28),PAL_RGB(  0, 27, 27),
    PAL_RGB( 38,  0, 34)
]

let paletteColours = palette.map { NSColor(rawColour: $0) }

///
/// Extension to allow palette origin
///
extension NSColor {
    convenience init(paletteIndex index: Int) {
        let raw = palette[index]
        self.init(calibratedRed: CGFloat(raw.red) / 255,
                  green: CGFloat(raw.green) / 255,
                  blue: CGFloat(raw.blue) / 255, alpha: 1)
    }

    convenience init(rawColour raw: RawColour) {
        self.init(calibratedRed: CGFloat(raw.red) / 255,
                  green: CGFloat(raw.green) / 255,
                  blue: CGFloat(raw.blue) / 255, alpha: 1)
    }
}
