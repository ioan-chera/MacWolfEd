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

//
// Editor view
//
class MapView: NSView {

    private let tileSize = 16

    //
    // The level
    //
    weak var level: Level? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    //
    // Main drawing function
    //
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let level = level else {
            return
        }

        for i in stride(from: 0, to: mapArea, by: 1) {
            if level.walls[i] == 0 || level.walls[i] >= ambushTile {
                floorColour.setFill()
            } else {
                NSColor.black.setFill()
            }
            let x = i % mapSize
            let y = i / mapSize
            CGRect(origin: CGPoint(x: x * tileSize, y: (mapSize - y - 1) * tileSize),
                   size: CGSize(width: tileSize, height: tileSize)).fill()
        }
    }
}
