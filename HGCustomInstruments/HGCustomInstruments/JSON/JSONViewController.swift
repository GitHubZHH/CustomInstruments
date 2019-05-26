//
//  JSONViewController.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import UIKit
import os

class JSONViewController: UIViewController {
    
    /// Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // log 句柄
        let parsingLog = OSLog(subsystem: "com.coderhg.json", category: "JSONDecode")
        
        // 开始
        os_signpost(.begin, log: parsingLog, name: "Parsing", "Parsing started")
        
        // 模拟: Decode the JSON we just downloaded
        let size = jsonDecode()
        
        // 结束
        os_signpost(.end, log: parsingLog, name: "Parsing", "Parsing finished SIZE:%ld", size)
    }

    /// 模拟事件
    func jsonDecode() -> UInt32 {
        // 0 ~ 3.0 秒的时间
        let timeOut = (arc4random()%6)/2
        sleep(timeOut)
        
        // 模拟当前解析字符串的大小
        let size = arc4random()%100 + 10
        return size
    }

}
