//
//  WNDetectionPathView.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Detection Paths View

struct WNDetectionPathView: View {
    
    // MARK: - View Model
    
    var viewModel: WNDetectionPathViewViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Rectangle()
                .path(in: viewModel.path)
                .fill(Color.red.opacity(0.5))
            Text(viewModel.text)
                .position(viewModel.textOrigin).minimumScaleFactor(0.5)
        }
    }
}

struct WNDetectionPathView_Previews: PreviewProvider {
    static var previews: some View {
        WNDetectionPathView(viewModel: WNDetectionPathViewViewModel(detectedPath: DetectedPath(path: .zero, id: "id", text: "text")))
    }
}
