//
//  AppDelegate.swift
//  TechViewCodable
//
//  Created by jhunter on 2018/8/22.
//  Copyright © 2018年 J.Hunter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        let person = Person()
//        person.identity = String(format: "3%04ld", 0)
//        person.name = String(format: "人名: %03ld", 0)
//        person.age = 20
//        person.phone = String(format: "13800000%03ld", 0)
//        do {
//            let string = try person.jsonStr()
//            print("\(String(describing: string))")
//            if let data = string?.data(using: .utf8) {
//                let person = try Person.initialization(data)
//                let id = person.identity
//                print("\(id)")
//            }
//        } catch {
//            print("\(error)")
//        }

        CompareUtil.shared.decodeDemo()
        
//        TestData.shared.generateJSONFile()

//        do {
//            let fullSub = FullSub()
//            fullSub.id = UUID()
//            fullSub.string = "FullSub"
//
//            let fullEncoder = JSONEncoder()
//            let fullData = try fullEncoder.encode(fullSub)
//            let fullString = String(data: fullData, encoding: .utf8)
//            print("\(String(describing: fullString))")
//
//            let fullDecoder = JSONDecoder()
//            let fullSubDecoded: FullSub = try fullDecoder.decode(FullSub.self, from: fullString!.data(using: .utf8)!)
//            print("\(fullSubDecoded)")
//        } catch {
//
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

