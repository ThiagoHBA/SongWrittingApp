//
//  WeakReference.swift
//  Main
//
//  Created by Thiago Henrique on 10/12/23.
//

import Presentation

final class WeakReferenceProxy<T: AnyObject> {
    weak var instance: T?

    init(_ instance: T) {
        self.instance = instance
    }
}
