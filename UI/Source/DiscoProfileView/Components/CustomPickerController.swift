//
//  CustomPickerController.swift
//  UI
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation
import Presentation
import UIKit
import UniformTypeIdentifiers

class CustomPickerController: UIDocumentPickerViewController {
    var section: SectionViewEntity?
    
    override init(forOpeningContentTypes contentTypes: [UTType], asCopy: Bool = true) {
        super.init(forOpeningContentTypes: contentTypes, asCopy: asCopy)
    }
    
    required init?(coder: NSCoder) { nil }
}
