//
//  ViewController.swift
//  ExampleNetworkMonitor
//
//  Created by Ravi Raja Jangid on 25/04/23.
//

import UIKit
import NetworkMonitor

class ViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusUpdateUsingBlockCallback: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NetworkMonitor.isConnected)
        ///Not recommended the use of 1,2,3
        ///1.
        NetworkMonitor.networkReachable = {
            print("####### Connected...")
            
        }
        ///2.
        NetworkMonitor.networkUnreachable = {
            print("####### Not Connected...")
        }
        ///3.
        NetworkMonitor.subscribe(observer: self)
        NetworkMonitor.startMonitoring()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///Recommended way of use 1,2,3 always used in viewWillAppear to subscribe and start monitoring and
        ///Stop & Unsubscribe in viewWillDisappear
        ///Same applied with blocks notifier initialise in viewWillAppear and deinitialise in viewWillDisappear
        
        ///1
        NetworkMonitor.subscribe(observer: self)
        NetworkMonitor.startMonitoring()
        
        ///2
        NetworkMonitor.networkReachable = {
            print("####### viewWillAppear Connected...")
            self.statusUpdateUsingBlockCallback.text = "Network Reachable"
        }
        ///3
        NetworkMonitor.networkUnreachable = {
            print("####### viewWillAppear Not Connected...")
            self.statusUpdateUsingBlockCallback.text = "Network Not Reachable"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkMonitor.stopMonitoring()
        NetworkMonitor.unSubscribe(observer: self)

        NetworkMonitor.networkReachable = nil
        NetworkMonitor.networkUnreachable = nil
    }

    
    @objc func reachabilityChanged(_ note: Notification) {

        print(NetworkMonitor.isConnected)
        if NetworkMonitor.isConnected {
            print("####### Connected...", note)
            status.text = "Connected"
        } else {
            print("###### Not connected...")
            status.text = "No Connected"
        }
    }
    
}

