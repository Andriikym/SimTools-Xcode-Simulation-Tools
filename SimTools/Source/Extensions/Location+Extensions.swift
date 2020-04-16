/**
*  SimTools
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import CoreLocation

extension CLLocationCoordinate2D {
    var toString: String {
        return ("\(self.latitude.toString(precision: 6)) \(self.longitude.toString(precision: 6))")
    }
}
