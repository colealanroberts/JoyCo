//
//  MealCell.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import Foundation
import NukeUI
import SwiftUI

struct MealCell: View {
    
    // MARK: Properties
    
    let meal: Meal
    let onTap: (Meal) -> Void
    
    // MARK: Body
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Spacer()
            HStack(spacing: Stylesheet.Spacings.medium) {
                // Image
                LazyImage(
                    url: URL(string: meal.thumbnailURL),
                    transaction: .init(animation: .smooth),
                    content: { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: Stylesheet.Images.thumbnail,
                                    height: Stylesheet.Images.thumbnail
                                )
                                .clipShape(RoundedRectangle(cornerRadius: Stylesheet.Corners.medium))
                        } else {
                            ThumbnailPlaceholderView()
                        }
                    }
                )
                
                // Title
                Text(meal.name)
                    .fontWeight(.semibold)
                    .fontDesign(.serif)
            }
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            onTap(meal)
        })
        .padding(.horizontal, Stylesheet.Spacings.medium)
    }
}
