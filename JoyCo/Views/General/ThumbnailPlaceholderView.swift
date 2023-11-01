//
//  ThumbnailPlaceholderView.swift
//  JoyCo
//
//  Created by Cole Roberts on 11/1/23.
//

import SwiftUI

struct ThumbnailPlaceholderView: View {
    
    // MARK: Properties
    
    private let size: CGSize
    private let cornerRadius: CGFloat
    
    // MARK: Init
    
    init() {
        self.init(
            size: .init(
                width: Stylesheet.Images.thumbnail,
                height: Stylesheet.Images.thumbnail
            ),
            cornerRadius: Stylesheet.Corners.medium
        )
    }
    
    init(
        size: CGSize,
        cornerRadius: CGFloat
    ) {
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    // MARK: Body
    
    var body: some View {
        Color.gray.opacity(0.2)
            .frame(
                width: size.width,
                height: size.height
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
