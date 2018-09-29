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

import Foundation

//
// Map content
//
class Level {
    var walls: [UInt16]
    var actors: [UInt16]
    var name: String

    init(walls: [UInt16], actors: [UInt16], name: String) {
        self.walls = walls
        self.actors = actors
        self.name = name
    }
}

///
/// Convenience stuff
///
func all8Neighbours(index: Int, operation: (Int) -> Bool) -> Bool {
    let x = index % mapSize
    let y = index / mapSize
    for dy in -1...1 {
        for dx in -1...1 {
            if (0 ..< mapSize).contains(x + dx) && (0 ..< mapSize).contains(y + dy) && dx | dy != 0 {
                if !operation(index + dx + dy * mapSize) {
                    return false
                }
            }
        }
    }
    return true
}

///
/// Visits 4 neighbours, in order of right, up, down, left
///
func all4Neighbours(index: Int, operation: (Int) -> Bool) -> Bool {
    let x = index % mapSize
    let y = index / mapSize
    if x < mapSize - 1 && !operation(index + 1) {
        return false
    }
    if y > 0 && !operation(index - mapSize) {
        return false
    }
    if y < mapSize - 1 && !operation(index + mapSize) {
        return false
    }
    if x > 0 && !operation(index - 1) {
        return false
    }
    return true
}

func isWall(tile: UInt16) -> Bool {
    return tile > 0 && tile < ambushTile
}
