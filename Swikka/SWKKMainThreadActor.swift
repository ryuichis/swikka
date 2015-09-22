//
//  SWKKMainThreadActor.swift
//  Swikka
//
//  Created by Ryuichi Saito on 9/21/15.
//  Copyright © 2015 Ryuichi Saito, LLC. All rights reserved.
//

import Foundation

public protocol SWKKMainThreadActor: SWKKActor {}

extension SWKKMainThreadActor {
    var dispatchQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
}
