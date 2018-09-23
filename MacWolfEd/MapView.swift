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
import CommonSwift

//
// Editor view
//
class MapView: NSView {

    /// Display tile size
    private let tileSize = 16

    /// Used for centering
    private var origin = NSPoint()

    //
    // The level
    //
    weak var level: Level? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    weak var vswap: VSwapContainer? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    //
    // Main drawing function
    //
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard
            let context = NSGraphicsContext.current?.cgContext,
            let level = level else
        {
            return
        }

        let maxWidth = CGFloat(tileSize * mapSize)
        origin.x = bounds.width > maxWidth ? (bounds.width - maxWidth) / 2 : 0
        origin.y = bounds.height > maxWidth ? (bounds.height - maxWidth) / 2 : 0

        for i in 0 ..< mapArea {
            let tile = level.walls[i]
            let x = i % mapSize
            let y = i / mapSize
            let rect = CGRect(origin: CGPoint(x: x * tileSize, y: (mapSize - y - 1) * tileSize),
                              size: CGSize(width: tileSize, height: tileSize)) + origin
            if tile == 0 || tile >= ambushTile {
                context.setFillColor(floorColour.cgColor)
                context.fill(rect)
            } else {
                let wallIndex = Int(tile) - 1
                if vswap != nil && wallIndex < vswap!.walls.count {
                    if let brightPic = vswap!.walls[wallIndex].brightPic {
                        context.draw(brightPic, in: rect)
                    }
                    continue
                } else {
                    NSColor.black.setFill()
                }
            }
        }
    }
}
