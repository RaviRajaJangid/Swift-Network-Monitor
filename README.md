# Swift Network Monitor

## NetworkMonitor
- It can be used to detect the network connectivity
# final class NetworkMonitor
# Type Properties
## static var enableLog: Bool
- set true if you want to see log by default its false
## static var isConnected: Bool
To check whether the network connection is available
## static var networkReachable: (() -> ())?
`networkReachable` is a callback block, It will be triggered once network is reachable
## static var networkUnreachable: (() -> ())?
networkUnreachable is a callback block, It will be triggered once network become unreachable
Type Methods
## class func startMonitoring()
Start Monitoring to the network change
## class func stopMonitoring()
Stop Monitoring to the network change
## class func subscribe(observer: AnyObject)
Subscribe to network change event and will be call the @obj func reachabilityChanged(_ note: Notification) in the observer class to notify
## class func unSubscribe(observer: AnyObject)
Unsubscribe to network change notifier to the whole app

# Installation 

## Swift Package Manager (SPM)
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. To integrate using Apple's Swift package manager from xcode :

File -> Swift Packages -> Add Package Dependency

Enter package URL :  https://github.com/RaviRajaJangid/swift-network-monitor, choose the latest release

# How to use
- Recomonded way to use block callback or change subscription event in controller viewWillAppear method
and call back should set to null in viewWillDisappear

[for more details you can check the example project in example folder](https://github.com/RaviRajaJangid/Swift-Network-Monitor/tree/main/Example
)