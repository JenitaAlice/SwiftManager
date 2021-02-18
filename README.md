# MSILLib

A framework with functions and decompression algorithms for working with various streaming connections. MSILLib framework is a swift package with a collection of functions for: 

    - JSON streaming
    - Binary streaming 
    - HTTP API calls

The SDK accommodates relevant methods for subscribing and unsubscribing Market data.


## Features:-

    - Create connection with socket stream
    - Close connection with socket stream
    - Subscribe to one or more market data
    - Unsubscribe one or multiple symbols
    - Unsubscribe all symbols
    - Easy implementation of REST API calls to load decoded data
    - Print console


## Installation:-

MSILLib can be integrated into your project using Swift Package Manager.

### Swift Package Manager:-

```
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: “https://git.assembla.com/msxtream.ios-sdk.git”, from: “1.0.0”)
    ],
    targets: [
        .target(
            name: "TargetName",
            dependencies: ["MSILLib"]
        )
    ]
)
```

Update for Xcode 11:- Swift package is integrated into Xcode 11. One of the given repository's URLs below can be used to add the framework to a project.

    - HTTPS  :     https://git.assembla.com/msxtream.ios-sdk.git
    - SSH         :   git@git.assembla.com:msxtream.ios-sdk.git


**Example**

>    - File > Swift Packages > Add Package Dependency
>    - Add git@git.assembla.com:msxtream.ios-sdk.git
>    - Select "Up to Next Major" with “1.0.0” or “Branch” with “MSILLib”


## Requirements:-

iOS 10+, Swift 4+


## Usage:-

In code import MSILLib SDK like so: 

```
import MSILLib
```

### Socket Connection

To connect with socket stream, configure streamer manager with details of: 

    - Streaming URL
    - Streaming port
    - Socket mode - TCP/TLS
    - Binary stream (Boolean)
    - Quote level - Quote/Quote2

**Example**
```
import MSILLib

let streamManager = StreamerManager()
Streaming is determined by the binary stream configuration.
streamManager.streamerConfig = StreamerConfig(socketHostUrl: “streaming_url", socketMode: SocketMode.TCP, socketHostPort: streaming_port)
```

**Create Connection:-**
```
streamManager.createConnection()
```

**Stop Connection:-**
```
streamManager.closeConnection()
```

**Socket Subscription:-**
```
streamManager.subscribe(syms: ["22_NSE"], objSub: self, sType: StreamLevel.quote)
```

**Socket Un-subscription:-**
```
streamManager.unSubscribe(aSym: "22_NSE", objSub: self, sType: StreamLevel.quote)
```

**Un-subscribe all:-**
```
streamManager.unSubscribeAll()
```

**Log console:-**
```
streamManager.logConfig.showLog = true
```


**StramerManagerDelegate:-**

A StramerManagerDelegate instance encapsulates handling of streaming response
```
func streamingResponseRecived<response>(response: response) where response : DataProvider {}
```

### HTTP Client:-

**Example**

```
import MSILLib

let netWorkWorker = MSFWebServiceWorker()
netWorkWorker.sendRequestWithMethod(url: "https://req.in/api", method: .post, res: Response()) { (jsonData) in
           // Response
        } failureHandler: { (error) in
           // Error
}
```
