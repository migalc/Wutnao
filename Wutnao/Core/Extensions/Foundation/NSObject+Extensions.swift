//
//  NSObject+Extensions.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: NSObject Extensions

extension NSObject {
    var className: String { String(describing: self) }
    class var className: String { String(describing: self) }
}
