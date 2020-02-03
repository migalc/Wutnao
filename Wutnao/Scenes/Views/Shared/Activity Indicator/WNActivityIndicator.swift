//
//  WNActivityIndicator.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Activity Indicator Implementation

struct WNActivityIndicator: UIViewRepresentable {
    
    // MARK: - View Model
    
    @ObservedObject var viewModel: WNActivityIndicatorViewModel
    
    // MARK: - UIViewRepresentable Functions
    
    func makeUIView(context: UIViewRepresentableContext<WNActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<WNActivityIndicator>) {
        viewModel.isLoading ? uiView.startAnimating() : uiView.stopAnimating()
    }
    
}

struct WNActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        WNActivityIndicator(viewModel: WNActivityIndicatorViewModel(isLoading: true))
    }
}
