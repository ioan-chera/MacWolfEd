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

let ambushTile = 106
let areaTile = 107
let floorColour = NSColor(calibratedRed: 0.4375, green: 0.4375, blue: 0.4375, alpha: 1)
let ambushColour = NSColor.magenta
let mapArea = mapSize * mapSize
let mapPlanes = 2   // number of planes per map
let mapSize = 64
let maxWallTiles = 64
let numMaps = 60    // fixed number of maps
let vgaCeilingWolf3D = [
    0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0xbf,
    0x4e, 0x4e, 0x4e, 0x1d, 0x8d, 0x4e, 0x1d, 0x2d, 0x1d, 0x8d,
    0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x2d, 0xdd, 0x1d, 0x1d, 0x98,

    0x1d, 0x9d, 0x2d, 0xdd, 0xdd, 0x9d, 0x2d, 0x4d, 0x1d, 0xdd,
    0x7d, 0x1d, 0x2d, 0x2d, 0xdd, 0xd7, 0x1d, 0x1d, 0x1d, 0x2d,
    0x1d, 0x1d, 0x1d, 0x1d, 0xdd, 0xdd, 0x7d, 0xdd, 0xdd, 0xdd
]
let vgaCeilingSpear = [
    0x6f, 0x4f, 0x1d, 0xde, 0xdf, 0x2e, 0x7f, 0x9e, 0xae, 0x7f,
    0x1d, 0xde, 0xdf, 0xde, 0xdf, 0xde, 0xe1, 0xdc, 0x2e, 0x1d, 0xdc
]

///
/// Game mode
///
enum GameMode {
    case wolf3d
    case spear
}

struct GameModeInfo {
    let numLevels: Int
    let ceilingColours: [Int]
}

let modeInfo: [GameMode: GameModeInfo] = [
    .spear: GameModeInfo(numLevels: 21, ceilingColours: vgaCeilingSpear),
    .wolf3d: GameModeInfo(numLevels: numMaps, ceilingColours: vgaCeilingWolf3D)
]
