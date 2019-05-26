;  duplicate-call-detection.clp
;  HGCustomInstruments
;
;  Created by hong.zhu on 2019/5/26.
;  Copyright © 2019 CoderHG. All rights reserved.

; 建模器
; 使用模板定义一个数据类型(同结构体)
(deftemplate started-download
    (slot time (type INTEGER))
    (slot caller-address (type INTEGER))
    (slot signpost-id (type INTEGER))
    (slot image-name (type STRING))
)

; 定义开始下载的规则
(defrule MODELER::record-download-started
    (os-signpost (subsystem "com.coderhg.imageload") (category "ImageLoad") (name "Background Image") (event-type "Begin") (message$ "Image name:" ?image-name ", Caller:" ?caller-address)
        (time ?time) (identifier ?identifier))
    =>
    (assert (started-download (time ?time) (caller-address ?caller-address) (signpost-id ?identifier) (image-name ?image-name)))
)

; 定义完成下载的规则
(defrule MODELER::record-download-finished
    (os-signpost (subsystem "com.coderhg.imageload") (category "ImageLoad") (name "Background Image") (event-type "End") (identifier ?identifier)
    )
    ?which <- (started-download (signpost-id ?identifier))
    =>
    (retract ?which)
)

; 开始与完成规则分析
(defrule RECORDER::record-download-started-by-the-same-object
    (started-download (time ?t1) (caller-address ?caller) (image-name ?img1))
    (started-download (time ?t2) (caller-address ?caller) (image-name ?img2))
    ; 同一个 signpost-id, 如果开始下载的时间大于完成下载的时间, 说明取消下载异常
    (test (> ?t1 ?t2))
    (table (table-id ?output) (side append))
    (table-attribute (table-id ?output) (has schema downloader-narrative))
    =>
    (create-new-row ?output)
    (set-column time ?t1)
    (set-column-narrative description "Duplicated requested made by object :%address%. It requested location %string% while having another request for %string% already running (started %event-time%)" ?caller ?img1 ?img2 ?t2)
)

; 其中 MODELER 与 RECORDER 都是 CLIPS 中的模块
; MODELER 表示数据的输入, RECORDER 表示数据的输出
