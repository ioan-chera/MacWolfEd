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
let mapArea = mapSize * mapSize
let mapPlanes = 2   // number of planes per map
let mapSize = 64
let maxWallTiles = 64
let numMaps = 60    // fixed number of maps
