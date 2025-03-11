//
//  ChallengePage.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import Foundation

public struct ChallengePage<Content: View>: View {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .center, spacing: AppConstants.UI.standardPadding) {
            content()
        }
        .padding(.horizontal, AppConstants.UI.standardPadding)
    }
}
