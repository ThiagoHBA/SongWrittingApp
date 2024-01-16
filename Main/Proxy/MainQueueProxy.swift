//
//  MainQueueProxy.swift
//  Main
//
//  Created by Thiago Henrique on 23/12/23.
//

import Foundation

final class MainQueueProxy<T: AnyObject> {
    let instance: T

    init(_ instance: T) {
        self.instance = instance
    }
}
