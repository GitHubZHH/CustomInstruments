//
//  OSLogViewController.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import UIKit
import os

class OSLogViewController: UITableViewController {
    
    var qLog:OSLog?
    var qQerial:OSLog?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                qQerial = OSLog(subsystem: "com.demo.serial", category: "serial")
                qLog = OSLog(subsystem: "com.demo.uni", category: "disabled")
            } else {
                qLog = OSLog.disabled
                qQerial = OSLog.disabled
            }
            return
        }
        
        switch indexPath.row {
        case 0:
            serial();
        case 1:
            funcDispatchQueue()
        case 2:
            funDispatchQueue()
        case 3:
            funEvent()
        case 4:
            let world = "world"
            os_log(.info, log: qLog ?? OSLog.disabled, "Hello, %{public}s!", world)
        default:
            print(0)
        }
    }
    
    // Event
    func funEvent() -> Void {
        
        let log = OSLog(subsystem: "com.demo.serial", category: .pointsOfInterest)
        os_signpost(.event, log: log, name: "Fetch Asset", "Fetched first chunk")
    }
    
    /// 22 异步统计
    func funDispatchQueue() -> Void {
        let log = OSLog(subsystem: "com.demo.serial", category: "asynchronous")
        
        let asSpid = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: "Fetch Panel", signpostID:asSpid)
        
        var count = 0
        for i in 0...3 {
            
            let spid = OSSignpostID(log: log, object: i as AnyObject)
            os_signpost(.begin, log: log, name: "Fetch Asset", signpostID:spid)
            
            // 开始异步
            DispatchQueue.global().async {
                // 随机的睡几秒钟
                let time = arc4random()%5 + 1
                sleep(time)
                os_signpost(.end, log: log, name: "Fetch Asset", signpostID:spid)
                
                // 回调主线程
                DispatchQueue.main.async {
                    count += 1;
                    
                    // 如果 == 4 说明已经全部结束
                    if count == 4 {
                        os_signpost(.end, log: log, name: "Fetch Panel", signpostID:asSpid)
                    }
                };
            };
        }
    }
    
    /// 11 同步统计
    func serial() -> Void {
        let log = qQerial ?? OSLog.disabled
        
        os_signpost(.begin, log: log , name: "Fetch Panel")
        
        for _ in 0...3 {
            os_signpost(.begin, log: log, name: "Fetch Asset")
            sleep(2)
            os_signpost(.end, log: log, name: "Fetch Asset")
            
            sleep(1)
        }
        
        os_signpost(.end, log: log, name: "Fetch Panel")
    }
    
    
    /// 00 异步中的不同 OS
    func funcDispatchQueue() -> Void {
        DispatchQueue.global().async {
            self.fun00();
        };
        
        DispatchQueue.global().async {
            self.fun11();
        };
        
        DispatchQueue.global().async {
            self.fun22();
        };
    }
    
    func fun00() -> Void {
        sleep(1)
        let osObj = OSLog(subsystem: "demo-subsystem1", category: "demo-Category1")
        os_signpost(OSSignpostType.begin, log: osObj, name: "demo-name1")
        
        sleep(4)
        
        os_signpost(OSSignpostType.end, log: osObj, name: "demo-name1")
    }
    
    func fun11() -> Void {
        sleep(2)
        let osObj = OSLog(subsystem: "demo-subsystem2", category: "demo-Category2")
        os_signpost(OSSignpostType.begin, log: osObj, name: "demo-name2")
        
        sleep(4)
        
        os_signpost(OSSignpostType.end, log: osObj, name: "demo-name2")
    }
    
    func fun22() -> Void {
        sleep(3)
        let osObj = OSLog(subsystem: "demo-subsystem3", category: "demo-Category3")
        os_signpost(OSSignpostType.begin, log: osObj, name: "demo-name3")
        
        sleep(4)
        
        os_signpost(OSSignpostType.end, log: osObj, name: "demo-name3")
    }

}
