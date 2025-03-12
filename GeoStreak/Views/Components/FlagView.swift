//
//  FlagView.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import SwiftUI

struct FlagView: View {
    let flag: String?
    var size: CGFloat = AppConstants.Layout.xxLarge * 2.5
    var showPlaceholder: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius)
                .fill(Color(uiColor: .systemGray6))
                .frame(width: size * 1.5, height: size * 1.3)
                .shadow(radius: 2)
            
            if let flag = flag {
                Text(flag)
                    .font(.system(size: size))
                    .padding()
            } else if showPlaceholder {
                Image(systemName: "flag.fill")
                    .font(.system(size: size * 0.5))
                    .foregroundColor(Color(uiColor: .systemGray2))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FlagView(flag: "🇺🇸", size: 80)
        FlagView(flag: "🇨🇦", size: 60)
        FlagView(flag: "🇯🇵", size: 40)
        FlagView(flag: nil, size: 60)
    }
    .padding()
}
