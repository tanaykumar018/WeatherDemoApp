//
//  AdaptiveViewModifier.swift
//  WeatherDemoApp
//
//  Created by Tanay Kumar Roy on 8/16/24.
//

import SwiftUI

struct AdaptiveViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.top, geometry.safeAreaInsets.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

