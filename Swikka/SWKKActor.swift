//
//  SWKKActor.swift
//  Swikka
//
//  Created by Ryuichi Saito on 9/21/15.
//  Copyright © 2015 Ryuichi Saito, LLC. All rights reserved.
//

import Foundation

public protocol SWKKActor  {
    var name: String { get }
    var dispatchQueue: dispatch_queue_t { get }
    
    func receive(message: Any)
}

extension SWKKActor {
    var dispatchQueue: dispatch_queue_t {
        let queueName = "com.ryuichisaito.swikka." + name
        return dispatch_queue_create(queueName.cStringUsingEncoding(NSUTF8StringEncoding)!, DISPATCH_QUEUE_SERIAL)
    }
    
    func receive(message: Any) {}
}

protocol SWKKMainThreadActor: SWKKActor {}

extension SWKKMainThreadActor {
    var dispatchQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
}

infix operator ! {}

public func ! (actor: SWKKActor, message: Any) -> Void {
    dispatch_async(actor.dispatchQueue) {
        actor.receive(message)
    }
}
