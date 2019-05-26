# CustomInstruments

## 0x000 准备  
建议先做如下两件事，如果不想看也没有关系：  
1、看 [Creating Custom Instruments](https://developer.apple.com/videos/play/wwdc2018/410)，因为当前文章就是看了这个教程草总结的。  
2、我实现的代码在这里 [CustomInstruments](https://github.com/GitHubZHH/CustomInstruments), 欢迎下载。   
3、下载之后，先看一下 `os_log 初体验` 中的简单例子，了解一下 `oslog` 与 `os_signpost` 的简单使用。  
4、需要简单的了解一下 [CLIPS 语法](https://juejin.im/post/5c5115376fb9a049c232d77c)。  
当前文章主要是根据 wwdc2018 & 410 中所提及到的内容进行实现，拿不到视频中的代码，那就只能自己模拟。  

## 0x001 创建自定义项目
这个很简单，直接通过这个界面的指示创建一个 Mac 项目即可。  
![](https://user-gold-cdn.xitu.io/2019/5/26/16af30de441f6ec6?w=876&h=630&f=png&s=106861)  
为了方便管理，我就直接在我的 `HGCustomInstruments` 项目中直接创建了，在实际开发中，如果这个工具是针对某个项目的话，这个会更方便些。创建之后是这样的：  

![HGTick](https://user-gold-cdn.xitu.io/2019/5/26/16af31130376d2a5?w=540&h=280&f=png&s=158030)
创建之后仅有一个源文件(.instrpkg)，关于 `instruments` 源文件问题，可以参考这个讨论：[Splitting up instruments code](https://forums.developer.apple.com/message/358619#358619)。  

**注意：** 这是一个 Mac 应用，应该这样去运行：  
![RunHGTick](https://user-gold-cdn.xitu.io/2019/5/26/16af317595c4f5a2?w=694&h=364&f=png&s=298237)  
运行成功之后，会弹出一个 Instruments 的副本弹框，仅用于当前调试 `HGTick` 用。在这里可以看到具体的信息：  

![](https://user-gold-cdn.xitu.io/2019/5/26/16af31c169c6f0e9?w=1860&h=908&f=png&s=807632)  
但是目前这个 `HGTick` 是不可用的，毕竟还没有开始写代码。  
相关代码介绍，请看下节分享。

## 0x010 HGTick  
打开文件（HGTick.instrpkg），是这样的：  

![](https://user-gold-cdn.xitu.io/2019/5/26/16af32035adc3f53?w=2050&h=1700&f=png&s=485302)  
注释很多，核心的代码没有多少。但是基本上可以知道这个代码是 `XML` 格式的，通过不同的标签标示不同的功能，如果图中的 `package` 的标签，标示一个包，紧接着是其子标签：`id`、`title` 与 `owner` 等等。接下来就要开始写代码了：  
```
<!-- 导入 tick 模块 相当于 `import` -->
<import-schema>tick</import-schema>
```
具体的含义在注释中已经有所体现，说明 `tick` 模块是系统已经存在的，我们直接通过 `import-schema` 标签进行导入即可。  
```
<!-- 开始构建一个 instrument  -->
<instrument>
    <id>com.coderhg.ticksinstrument</id>
    <title>Ticks-IT</title>
    <category>Behavior</category>
    <purpose>tick demo</purpose>
    <icon>Generic</icon>
    
    <!-- 创建一个表, 这个表中使用到了 `tick`  -->
    <create-table>
        <id>tick-table</id>
        <schema-ref>tick</schema-ref>
    </create-table>
    
    <!-- 轨道视图 -->
    <graph>
        <title>Ticks-GH</title>
        <lane>
            <title>Ticks-LE</title>
            <table-ref>tick-table</table-ref>
            
            <!-- 轨道视图显示的数据 -->
            <plot>
                <value-from>time</value-from>
            </plot>
        </lane>
    </graph>
    
    <!-- 详情视图 -->
    <list>
        <title>Ticks-LT1</title>
        <table-ref>tick-table</table-ref>
        <column>time</column>
    </list>
    
    <list>
        <title>Ticks-LT2</title>
        <table-ref>tick-table</table-ref>
        <column>time</column>
    </list>
</instrument>
```  
这就是核心实现 `Instruments` 功能的代码了，详细解释如下：  
1、使用了 `Instrument` 之后依旧需要添加对应的标识、标题等基本信息。  
2、需要创建一个对这个自定义的 `Instrument` 需要有一张对应的表（table），故需要使用 `create-table`,值得注意的是这个表所需要的数据是直接来自于 ` tick` schema。  
3、开始创建一个轨道视图，这个轨道视图的数据来自 `tick-table` 这张表，由于这张表引用系统的 ` tick` schema，`tick` 中有一个 time 属性，所以可以直接使用这个时间戳字段。  
4、详情视图，使用 `list` 标签主要是在详情视图中显示数据的。这个 `list` 相当于我们开发中的 `UITableView`，`tick-table` 相当于数据源（dataSource）。  
选择 `HGTick` 

![](https://user-gold-cdn.xitu.io/2019/5/26/16af3674d23ca5ba?w=2698&h=1692&f=png&s=1090372)   
运行效果如下： 
![](https://user-gold-cdn.xitu.io/2019/5/26/16af36b0c5d051f9?w=1800&h=804&f=png&s=256639)  
至此、一个简单的自定义功能就完成了。总结一下：  
1、使用了一个系统已有的 `schema`，叫 `tick`。  
2、然后就是通过 `tick` 中提供的 `time` 属性为自定义的表格提供数据。  
3、并通过轨道视图与详情视图显示。 

**注意：** 这个例子没有实际的意义，仅仅是为了后面的介绍，做一个简单的铺垫。  

## 0x011 HGJSONDecode
这个主要是模拟解析 JSON 字符串的，为了简单起见，我就弄一个模拟 JSON 的方法。这个需要对开发的项目代码有侵入性的。所以将模拟的代码如下：  
```
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
```
**注意：** 这是在我们开发的代码，我们主要是为了检测 jsonDecode 方法的，在这里生成一个随机数来标识解析所需的时间。  
其实，通过以上的代码已经发现出现了其它的代码，主要是 `os_signpost` api。是的，这个就是为了结合自定义 Instruments 的时候使用的，只能在这里写了开始与结束，在自定义中才能有所匹配，才能做更精细的分析。

接下来就是看看在对应的 `HGJSONDecode.instrpkg` 文件中的实现。  
**os-signpost-interval-schema** 标签使用，目的是自定义一个 `schema`，具体的如下所示：  
```
<!-- 可以理解成一个数据来源 -->
<os-signpost-interval-schema>
    <id>json-parse</id>
    <title>JSON Decode</title>
    
    <!-- 这三个是与项目中一一对应 -->
    <subsystem>"com.coderhg.json"</subsystem>
    <category>"JSONDecode"</category>
    <name>"Parsing"</name>
    
    <!-- 开始匹配-->
    <start-pattern>
        <message>"Parsing started"</message>
    </start-pattern>
    
    <!-- 结束匹配-->
    <end-pattern>
        <message>"Parsing finished SIZE:" ?data-size-value</message>
    </end-pattern>
    
    <!-- 表中的一列 -->
    <column>
        <!-- 助记符标识, 在 graph 与 list 中只认这个标识 -->
        <mnemonic>data-size</mnemonic>
        <title>JSON Data Size</title>
        <!-- 数据的类型 size-in-bytes -->
        <type>size-in-bytes</type>
        <!-- 显示 data-size 的值  -->
        <expression>?data-size-value</expression>
    </column>
    
    <!-- https://help.apple.com/instruments/developer/mac/current/#/dev66257045 -->
    <column>
        <mnemonic>impact</mnemonic>
        <title>Impact</title>
        <type>event-concept</type>
        <expression>(if (&gt; ?data-size-value 80) then "High" else "Low")</expression>
    </column>
    
</os-signpost-interval-schema>
```
上面的代码，凭借自己的开发经验，应该是能看懂的，即使是我每一偶告诉你这是另一门编程语言：[CLIPS](https://www.jianshu.com/p/0b023d5a96f3)。自信观察 `start-pattern` 与 `end-pattern` 这两个标签，就应该明白其含义：主要是获取项目中JSON 解析的开始与结束的。其中在结束的时候会匹配出项目中的元数据：解析字符的大小。这里主要使用的就是 CLIPS 语言的变量。接着就是 `column`, 这个标签即使为这个 `shema` 定义一些字段，在这里也发现，这里提到的 `schema` 很像一个数据库。其中这个是数据库中有两个 key：`data-size` 与 `impact`，其中 `impact` 是由 `data-size-value` 的值决定的，大于 `80` 时值是 `High`， 否则为 `Low`。    
剩余的部分，就与 `HGTick` 中的类似了。最终的效果是这样的：  

![](https://user-gold-cdn.xitu.io/2019/5/26/16af3af86b0cd0fe?w=1800&h=1316&f=png&s=393507)

这样就是很清楚的看到每次 JSON 解析的开始与结束，以及执行所花的时间。在实际开发中可能还会同时选中其它的调试模块，比如 `Time Profiler`、`内存检测` 等，这样能很好的全方位的分析当前的运行环境以及运行状态。  

## 0x1000 HGImageDownload  
主要就是模拟图片下载的例子，项目中的核心代码，如下：  
```
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
```  
换句话来说，就是模拟图片下载，然后在上面的代码中进行 `os_signpost` 调用。主要是看 **HGImageDownload** 中的实现。关于这部分，内容相对比较多，但是相比于前面两个主要多了建模器的构建相关的内容。
这部分，不打算在这里 copy 代码，根据上面的介绍通过项目代码应该很容易能理解。主要关注的标签是：`point-schema`、`modeler`、`aggregation` 与 `narrative`，以及 CLIPS 文件 `uplicate-call-detection.clp` 。  
最终的运行效果是：  

![List：Downloads](https://user-gold-cdn.xitu.io/2019/5/26/16af45628498e9e0?w=2568&h=1698&f=png&s=795944)  


![Narrative](https://user-gold-cdn.xitu.io/2019/5/26/16af4584d8b031e2?w=2568&h=1698&f=png&s=1331501)  
关于第二张的详情视图显示有点问题，但是不耽误学习。

## 0x1001 总结
主要是围绕 [WWDC2018/410](https://developer.apple.com/videos/play/wwdc2018/410) 进行介绍。  
1、**HGTick** 简单的使用了一下系统的 schema `tick` 模块，基本认识了自定义 Instruments 的套路以及基本格式。  
2、**HGJSONDecode** 自定义了一个 schema 从项目中通过 os_signpost 获取感兴趣的信息，获取元数据最终进行分析以及显示。  
3、通过 **HGImageDownload** 实现了自定义 Instruments 的高级应用，主要是建模器的构建。  

**综上：** 通过当前介绍，基本上能知道自定义 Instruments 的流程已经相关应用。


### 参考文章  
[使用 Instruments 检测内存泄漏](https://juejin.im/post/59a672f96fb9a02493222a1b)  
[WWDC 2018：创建自定义的 Instrument](https://juejin.im/post/5b1cd1025188257d72709d7f)  
