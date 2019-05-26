//
//  HGImageDownload.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import UIKit
import os.signpost

class HGMockData {
    /// 图片名
    var name:String?
    
    /// 图片下载的时间
    var needTime:Int?
    
    init() {
        //  随机数字
        needTime = (Int)(arc4random() % 4) + 1
    }
}

/// 下载状态
///
/// - HGImageLoadStatusUnkown: 未知
/// - HGImageLoadStatusIng: 开始
/// - HGImageLoadStatusFinish: 完成
/// - HGImageLoadStatusCancel: 取消
enum HGImageLoadStatus {
    case HGImageLoadStatusUnkown
    case HGImageLoadStatusIng
    case HGImageLoadStatusFinish
    case HGImageLoadStatusCancel
}


class HGImageDownload {
    /// mock 数据
    var mockData:HGMockData? {
        didSet {
            name = mockData?.name
            needTime = mockData?.needTime
        }
    }
    
    /// 图片名
    var name:String?
    
    /// 图片下载的时间
    var needTime:Int?
    
    /// 定时器
    var timer:DispatchSourceTimer?
    
    weak var obj:AnyObject?
    
    /// 下载状态
    var loadStatus:HGImageLoadStatus? {
        didSet {
            // 未知
            if loadStatus == .HGImageLoadStatusUnkown {
                return
            }
            
            // ID
            let signpostID = OSSignpostID(log: HGSignpostLog.imageLoadLog, object: self.obj!)
            let address = unsafeBitCast(self.mockData!, to: UInt.self)
            
            // 开始
            if loadStatus == .HGImageLoadStatusIng {
                os_signpost(.begin, log: HGSignpostLog.imageLoadLog, name: "Background Image", signpostID: signpostID, "Image name:%{public}@, Caller:%lu", name!, address)
                return
            }
            
            var status = "finish"
            // 完成
            if loadStatus == .HGImageLoadStatusFinish {
                
            }
            
            // 取消
            if loadStatus == .HGImageLoadStatusCancel {
                status = "cancel"
            }
            
            os_signpost(.end, log: HGSignpostLog.imageLoadLog, name: "Background Image", signpostID: signpostID, "Status:%{public}@, Size:%lu", status, needTime!)
        }
    }
    
    /// init
    init() {
        loadStatus = .HGImageLoadStatusUnkown
    }
    
    // 开始下载 (模拟)
    func start(obj:AnyObject) -> Void {
        
        clearTime();
        
        self.obj = obj
        loadStatus = .HGImageLoadStatusIng
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        let timerInterval = (Double)(needTime!)
        timer?.schedule(wallDeadline: .now()+timerInterval, repeating: 9999999999)
        timer?.setEventHandler {
            [weak self] in
            self?.loadStatus = .HGImageLoadStatusFinish
            
            self?.timer?.setEventHandler(handler: {
                
            })
            self?.timer?.setCancelHandler(handler: {
                
            })
        }
        
        timer?.resume()
    }
    
    // 取消
    func cancel(obj:AnyObject) -> Void {
        self.obj = obj
        if loadStatus != .HGImageLoadStatusFinish {
            if timer != nil {
                self.loadStatus = .HGImageLoadStatusCancel
                clearTime();
            }
        }
    }
    
    // 清空定时器
    private func clearTime() {
        // 清空之前的操作
        if let t = timer {
            
            t.setEventHandler {}
            
            timer = nil
        }
    }
}
