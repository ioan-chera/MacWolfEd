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
// Error handling
//
enum LevelSetError: Error {
    case missingFiles
}

//
// Wolf3D level set
//
class LevelSet {

    //
    // Load levels from folder
    //
    init(folder: URL) throws {
        var mapping: [String: URL?] = [
            "gamemaps.wl6": nil,
            "maphead.wl6": nil
        ]

        if try !checkHaveFiles(url: folder, mapping: &mapping) {
            throw LevelSetError.missingFiles
        }

        let gamemapsURL = mapping["gamemaps.wl6"]!
        let mapheadURL = mapping["maphead.wl6"]!
        // TODO: load maps from this point
    }
}
