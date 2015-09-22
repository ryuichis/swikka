//
//  SWKKOperator.swift
//  Swikka
//
//  Created by Ryuichi Saito on 9/21/15.
//  Copyright © 2015 Ryuichi Saito, LLC. All rights reserved.
//

import Foundation

infix operator ! {}

public func ! (left: SWKKActor, right: Any) -> Void {
    dispatch_async(left.dispatchQueue) {
        left.receive(right)
    }
}
