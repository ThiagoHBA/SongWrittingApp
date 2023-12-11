//
//  SelectedReferenceTableViewCell.swift
//  UI
//
//  Created by Thiago Henrique on 11/12/23.
//

import UIKit
import Presentation
import SwiftUI

struct SelectedReferenceListView: View {
    @ObservedObject var itemModel: SelectedReferenceListModel
    var selectedReferenceTapped: ((AlbumReferenceViewEntity) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(itemModel.items, id: \.id) { item in
                    Text(item.refernce.name)
                        .padding(6)
                        .foregroundStyle(.blue)
                        .background(.gray.opacity(0.4))
                        .clipShape(Capsule())
                        .onTapGesture {
                            selectedReferenceTapped?(item.refernce)
                        }
                }
            }
        }
    }
}
