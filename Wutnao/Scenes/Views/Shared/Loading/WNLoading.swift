//
//  WNLoading.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Loading View Implementation

struct WNLoading: View {
    
    // MARK: - View Model
    
    @ObservedObject var viewModel: WNLoadingViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            WNActivityIndicator(viewModel: WNActivityIndicatorViewModel(isLoading: viewModel.isLoading))
            Text(viewModel.loadingMessage)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black.opacity(0.6))
    }
}

struct WNLoading_Previews: PreviewProvider {
    static var previews: some View {
        WNLoading(viewModel: WNLoadingViewModel(isLoading: true, loadingMessage: "Loading"))
    }
}
