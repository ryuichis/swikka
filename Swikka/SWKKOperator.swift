//
//  SWKKOperator.swift
//  Swikka
//
//  Created by Ryuichi Saito on 9/21/15.
//  Copyright © 2015 Ryuichi Saito, LLC. All rights reserved.
//

import Foundation

infix operator ! {}

public func ! (actor: SWKKActor, message: Any) -> Void {
    dispatch_async(actor.dispatchQueue) {
        actor.receive(message)
    }
}
