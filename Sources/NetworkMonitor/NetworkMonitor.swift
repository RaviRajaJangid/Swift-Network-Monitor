//**************************************************************************************************************
//*
//*  Created By Ravi Raja Jangid 
//*  
//*  Created for Public use in 2021
//*  
//*  Using Swift 5.0
//*  
//*  Running on macOS 11.6
//*
//**************************************************************************************************************


import Foundation
///To detect the network connectivity
public final class NetworkMonitor {
    ///networkReachable is a callback block, It will be triggered once network is reachable
    public static var networkReachable: (() -> ())? {
        didSet{
            NetworkMonitor.monitor.reachability?.whenReachable = { reachability in
                networkReachable?()
            }
        }
    }
    
    ///networkUnreachable is a callback block, It will be triggered once network become unreachable
    public static var networkUnreachable: (() -> ())? {
        didSet{
            NetworkMonitor.monitor.reachability?.whenUnreachable = { reachability in
                networkUnreachable?()
            }
        }
    }
    /// set true if you want to see log by default its false
    public static var enableLog: Bool = false
    
    private static let monitor = NetworkMonitor()
    private var reachability: Reachability?
    private let hostName: String
   
    private init(hostName: String = "www.apple.com", logging: Bool = false) {
        //Setup reachability
        self.hostName = hostName
        NetworkMonitor.enableLog = logging
        if let reachability = try? Reachability(hostname: hostName) {
            self.reachability = reachability
        }
        else {
            self.reachability = try? Reachability()
        }
    }
    
    /// To check whether the network connection is available
    public static var isConnected: Bool {
        get {
            return monitor.reachability?.connection != .unavailable
        }
    }
    
    private class func log(_ log: String){
        if enableLog {
            print("NetworkMonitor: ",log)
        }
    }
    /// Subscribe to network change event and will be call the `@obj func reachabilityChanged(_ note: Notification)` in the `observer` class to notify
    /// - Parameter observer:  AnyObject type that can subscribe to the network change monitor
    public class func subscribe(observer: AnyObject) {
        //Stoping existing notifier
        NetworkMonitor.unSubscribe(observer: observer)
        //Adding reachability notifier
        log("Subscribe to \(String(describing: observer))")
        NotificationCenter.default.addObserver(
            observer,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: NetworkMonitor.monitor.reachability
        )
        if let _ = NetworkMonitor.monitor.reachability {
           startMonitoring()
        }
    }
    
    
    
    /// Unsubscribe to network change notifier to the whole app
    /// - Parameter observer: AnyObject type that will subscribe the network change monitor
    public  class func unSubscribe(observer: AnyObject) {
        log("Unsubscribe to \(String(describing: observer))")
        NotificationCenter.default.removeObserver(observer, name: .reachabilityChanged, object: NetworkMonitor.monitor.reachability)
    }
    
    
    /// Start Monitoring for network change
    public class func startMonitoring() {
        if NetworkMonitor.monitor.reachability?.notifierRunning == false {
            do {
                try NetworkMonitor.monitor.reachability?.startNotifier()
                log("Monitoring started")
            } catch let error {
                log("Unable to start monitoring \(error.localizedDescription)")
                return
            }
        }
    }
    
    /// Stop Monitoring for network change
    public class func stopMonitoring() {
        log("Monitoring stopped")
        NetworkMonitor.monitor.reachability?.stopNotifier()
        NetworkMonitor.monitor.reachability = nil
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let obj = note.object as! Reachability
        NetworkMonitor.log("reachabilityChanged in Package \(obj)")
    }
    
    deinit {
        NetworkMonitor.log("NetworkMonitor deinitialised")
        reachability?.stopNotifier()
    }
}
