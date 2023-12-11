//
//  ReferenceList.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import SwiftUI

struct ReferenceListView: View {
    @ObservedObject var itemModel: ItemListModel
    
    var body: some View {
        if itemModel.items.isEmpty {
            Text("Você ainda não possui nenhuma referência ao disco")
                .multilineTextAlignment(.center)
                .font(.caption)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(itemModel.items, id: \.id) { item in
                        Circle()
                            .stroke(style: .init(lineWidth: 0.5))
                            .frame(width: 80, height: 80)
                            .clipped()
                            .overlay {
                                if let image = item.image {
                                    AsyncImage(
                                        url: image,
                                        content: { image in
                                            image.resizable()
                                                 .aspectRatio(contentMode: .fill)
                                                 .clipShape(Circle())
                                        },
                                        placeholder: {
                                            ProgressView()
                                        }
                                    )
                                }
                            }
                            
                    }
                }
            }
        }
    }
}
