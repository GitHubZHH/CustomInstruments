//
//  ImageDownloadViewController.swift
//  HGCustomInstruments
//
//  Created  by hong.zhu on 2019/5/26.
//  Copyright © 2019 CoderHG. All rights reserved.
//

import UIKit

class ImageDownloadViewController: UITableViewController {
    /// 所有的图片数据
    var datas:[HGImageDownload] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mock 数据
        var mock:[HGMockData] = []
        for i in 1...10 {
            let mockData = HGMockData()
            mockData.name = "name\(i)"
            mock.append(mockData)
        }
        
        for _ in 0...300 {
            let index_ = (Int)(arc4random()%(UInt32)(mock.count))
            let mockData = mock[index_]
            
            let imageData = HGImageDownload()
            imageData.mockData = mockData;
            
            datas.append(imageData)
        }
    }
}

/// UITableViewDataSource
extension ImageDownloadViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HGImageDownloadCell
        
        let imageData = datas[indexPath.row]
        cell.imageData = imageData
        
        return cell
    }
}


