//
//  HGImageDownloadCell.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import UIKit

class HGImageDownloadCell: UITableViewCell {

    var imageData:HGImageDownload? {
        
        didSet {
            textLabel?.text = imageData?.name
            detailTextLabel?.text = "所需时间 \(imageData?.needTime ?? 0)"
            
            // 取消之前下载
            if let value = oldValue {
                if let l = value.loadStatus {
                    if l != .HGImageLoadStatusFinish {
                        value.cancel(obj: self)
                    }
                }
            }
            
            // 开始当前下载
            if let value = imageData {
                if let l = value.loadStatus {
                    if l != .HGImageLoadStatusFinish {
                        value.start(obj: self)
                    }
                }
            }
        }
    }

}
