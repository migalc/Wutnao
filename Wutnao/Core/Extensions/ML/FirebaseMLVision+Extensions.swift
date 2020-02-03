//
//  FirebaseMLVision+Extensions.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import FirebaseMLVision

// MARK: FirebaseMLVision Extensions

extension VisionTextElement {
    
    var pathRect: CGRect { getPathRect() }
    
    private func getPathRect() -> CGRect {
        let path = UIBezierPath()
        cornerPoints?
            .compactMap { $0 as? CGPoint }
            .enumerated()
            .forEach {
                if $0.offset == 0 { path.move(to: $0.element) }
                else { path.addLine(to: $0.element) }
                
        }
        path.close()
        return path.bounds
    }
    
}
