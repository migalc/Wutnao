//
//  WNObject.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

import Foundation

protocol WNObject {
    var className: String { get }
    static var className: String { get }
}

extension WNObject {
    var className: String { String(describing: self) }
    static var className: String { String(describing: self) }
}
