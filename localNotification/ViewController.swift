//
//  ViewController.swift
//  localNotification
//
//  Created by MobioApp on 12/26/17.
//  Copyright © 2017 MobioApp. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().delegate = self
        
        
    }
    
    @IBAction func passNotificationButton(_ sender: Any) {
        
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                print("not allowed")
                self.requestForNotification()
                
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
                print("Allowed")
                
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
        
    }
    
    
    
    func requestForNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        
        let options:UNAuthorizationOptions = [.alert, .sound,.badge]
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { (success, error) in
            if success {
                print("Schedule Local Notification")
            }
        }
        
    }
    
    private func scheduleLocalNotification() {
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        // Configure Notification Content
        notificationContent.title = "Mobio"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "In this tutorial, you learn how to schedule local notifications with the User Notifications framework."
        notificationContent.sound = UNNotificationSound.default()

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
        
    }
   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
        print("will present called")
    }
    
    
    
    
    
  
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
            
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            
        case "Snooze":
            print("Snooze")
            
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

