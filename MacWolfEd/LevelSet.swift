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
        let files = try findSubpaths(url: folder, fileNames: ["gamemaps.wl6", "maphead.wl6"])

        guard let gamemapsURL = files["gamemaps.wl6"], let mapheadURL = files["maphead.wl6"] else {
            throw LevelSetError.missingFiles
        }

    }
}
