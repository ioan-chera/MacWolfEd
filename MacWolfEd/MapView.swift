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

    private static let areaColours = paletteColours.map { $0.withAlphaComponent(0.5) }

    /// Display tile size
    private let tileSize = 32

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

    ///
    /// The default background colour
    ///
    var backgroundColour: NSColor = floorColour {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    //
    // The graphics
    //
    weak var vswap: VSwapContainer? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    ///
    /// Needed
    ///
    override var acceptsFirstResponder: Bool {
        return true
    }

    ///
    /// Animates in case of level change
    ///
    func animateLevelTransition(levelDifference: Int) {
        let transition = CATransition()
        transition.duration = 0.3
        if levelDifference > 0 {
            transition.type = .push
            transition.subtype = .fromRight
        } else {
            transition.type = .push
            transition.subtype = .fromLeft
        }
        layer?.add(transition, forKey: "transition")
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

        func areaToIndex(_ tile: UInt16) -> Int {
            return ((Int(tile) - areaTile) * 3) & 0xff
        }

        let maxWidth = CGFloat(tileSize * mapSize)
        origin.x = bounds.width > maxWidth ? (bounds.width - maxWidth) / 2 : 0
        origin.y = bounds.height > maxWidth ? (bounds.height - maxWidth) / 2 : 0

        context.setFillColor(backgroundColour.cgColor)
        context.fill(NSRect(origin: origin, size: CGSize(width: maxWidth, height: maxWidth)))

        guard let vswap = vswap else {
            return
        }

        for i in 0 ..< mapArea {
            let tile = level.walls[i]
            let x = i % mapSize
            let y = i / mapSize
            let rect = CGRect(origin: CGPoint(x: x * tileSize, y: (mapSize - y - 1) * tileSize),
                              size: CGSize(width: tileSize, height: tileSize)) + origin
            if isWall(tile: tile) {
                let wallIndex = Int(tile) - 1
                if wallIndex < vswap.walls.count {
                    let concealed = all8Neighbours(index: i) { (index) -> Bool in
                        return isWall(tile: level.walls[index])
                    }
                    let wallData = vswap.walls[wallIndex]
                    if let pic = concealed ? wallData.darkPic : wallData.brightPic {
                        context.draw(pic, in: rect)
                    }
                    continue
                }
                continue
            }
            if tile == ambushTile {
                var takenIndex = -1
                if !all4Neighbours(index: i, operation: { takenIndex = $0; return level.walls[$0] < areaTile }) {
                    let areaIndex = areaToIndex(level.walls[takenIndex])
                    context.setFillColor(MapView.areaColours[areaIndex].cgColor)
                    context.fill(rect)
                }
                let insetRect = rect.insetBy(dx: CGFloat(tileSize / 8), dy: CGFloat(tileSize / 8))
                context.setStrokeColor(ambushColour.cgColor)
                context.move(to: insetRect.origin)
                context.addLine(to: insetRect.origin + insetRect.size)
                context.move(to: insetRect.origin + NSSize(width: insetRect.width, height: 0))
                context.addLine(to: insetRect.origin + NSSize(width: 0, height: insetRect.height))
                context.strokePath()
                continue
            }

            let areaIndex = areaToIndex(tile)
            context.setFillColor(MapView.areaColours[areaIndex].cgColor)
            context.fill(rect)
        }
    }
}
