//
//  ErrorView.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import SwiftUI

struct ErrorView: View {
    
    // MARK: Public Properties
    
    let text: String
    let actions: [Action]?
    
    init(
        text: String,
        action: Action
    ) {
        self.init(text: text, actions: [action])
    }
    
    init(
        text: String,
        actions: [Action]? = nil
    ) {
        self.text = text
        self.actions = actions
    }
    
    // MARK: Body
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(spacing: Stylesheet.Spacings.medium) {
                Text(text)
                    .foregroundStyle(.secondary)
                
                if let actions {
                    HStack {
                        ForEach(actions) { action in
                            Button(action: action.onTap, label: {
                                Text(action.title)
                            })
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - ErrorView+Action -

extension ErrorView {
    struct Action: Identifiable {
        /// The associated identifier.
        var id: String { title }
        
        /// The text for the action.
        let title: String
        
        /// The closure to perform when tapping on the action.
        let onTap: () -> Void
    }
}
