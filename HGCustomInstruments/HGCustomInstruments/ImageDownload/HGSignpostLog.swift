//
//  HGSignpostLog.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import os.signpost

final class HGSignpostLog {
    
    /// log Object
    static let imageLoadLog = OSLog(subsystem: "com.coderhg.imageload", category: "ImageLoad")
    
    /// pointsOfInterst log Object
    static let pointsOfInterst = OSLog(subsystem: "com.coderhg.imageload", category: OSLog.Category.pointsOfInterest)
}
