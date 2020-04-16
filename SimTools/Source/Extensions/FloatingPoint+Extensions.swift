/**
*  SimTools
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation

extension FloatingPoint where Self: CVarArg {
    /**
     Return string with precision.
     For example 0.1234.toString(precision: 2) -> 0.12
     */
    func toString(precision: Int? = nil) ->String {
        if let precision = precision {
            return String(format: "%.\(precision)f", self)
        } else {
            return String(describing: self)
        }
    }
}

