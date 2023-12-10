//
//  ReferenceList.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import SwiftUI

struct IdentifiableItem: Identifiable {
    var id: UUID = UUID()
    var image: UIImage
}

struct ReferenceListView: View {
    @State var items: [IdentifiableItem] = []
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items, id: \.id) { item in
                    Circle()
                        .stroke(style: .init(lineWidth: 0.5))
                        .frame(width: 80, height: 80)
                        .overlay {
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFill()
                                .padding()
                        }
                }
            }
        }
    }
}
