//
//  RecipeView.swift
//  JoyCo
//
//  Created by Cole Roberts on 11/1/23.
//

import NukeUI
import SwiftUI

struct RecipeView: View {
    
    // MARK: Properties
    
    let recipe: Recipe
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Stylesheet.Spacings.large
        ) {
            // Hero Image
            LazyImage(
                url: URL(string: recipe.thumbnailURL),
                transaction: .init(animation: .smooth),
                content: { state in
                    if let image = state.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: Stylesheet.Images.hero,
                                maxHeight: Stylesheet.Images.hero
                            )
                            .clipped()
                    } else {
                        ThumbnailPlaceholderView(
                            size: .init(
                                width: Stylesheet.Images.hero,
                                height: Stylesheet.Images.hero
                            ),
                            cornerRadius: 0
                        )
                    }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: Stylesheet.Images.hero)
            
            // Content
            VStack(
                alignment: .leading,
                spacing: Stylesheet.Spacings.large
            ) {
                // Title
                Text(recipe.name)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .font(.title)
                
                // Igredients
                VStack(
                    alignment: .leading,
                    spacing: Stylesheet.Spacings.small
                ) {
                    Section("Ingredients") {
                        ForEach(recipe.ingredients) {
                            Text($0.displayText)
                        }
                    }
                }
                
                VStack(
                    alignment: .leading,
                    spacing: Stylesheet.Spacings.small
                ) {
                    // Instructions
                    Section("Instructions") {
                        Text(recipe.instructions)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - RecipeView+Section -

fileprivate extension RecipeView {
    struct Section<Content: View>: View {
    
        // MARK: Properties
        
        let title: String
        @ViewBuilder var content: () -> Content
        
        // MARK: Init
        
        init(
            _ title: String,
            @ViewBuilder content: @escaping () -> Content
        )  {
            self.title = title
            self.content = content
        }
        
        // MARK: Body
        
        var body: some View {
            VStack(
                alignment: .leading,
                spacing: Stylesheet.Spacings.medium
            ) {
                HStack {
                    Rectangle().fill(
                        Stylesheet.Colors.brandYellow
                    )
                    .frame(width: Stylesheet.Spacings.tiny)
                    
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.serif)
                }
                content()
            }
        }
    }
}
