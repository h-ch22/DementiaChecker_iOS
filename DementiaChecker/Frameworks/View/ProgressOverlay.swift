//
//  ProgressOverlay.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct ProgressOverlay: View {
    var body: some View {
        ProgressView()
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.white).opacity(0.5))
    }
}

#Preview {
    ProgressOverlay()
}
