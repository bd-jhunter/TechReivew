//
//  CompareUtil.swift
//  TechViewCodable
//
//  Created by jhunter on 2018/8/31.
//  Copyright © 2018 J.Hunter. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompareUtil {
    static let shared = CompareUtil()

    func simpleDemo() {
        if let path = Bundle.main.path(forResource: "simple", ofType: "json") {
            do {
                let jsonString = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
                _ = try Job.initialization(jsonString)
            } catch {}
        }
        
    }
    
    func decodeDemo() {
        if true {
            let beginNano = Ticktock.shared.absluteTime()
            var result: Company?
            for _ in 0...10000 {
                result = decodeWithCodable()
            }
            let endNano = Ticktock.shared.absluteTime()
            let cost = Ticktock.shared.convert(beginNano, end: endNano)
            print("[Codable] - Cost is \(cost) ms")
        }
        
        if true {
            let beginNano = Ticktock.shared.absluteTime()
            var result: Company?
            for _ in 0...10000 {
                result = decodeWithSwiftyJSON()
            }
            let endNano = Ticktock.shared.absluteTime()
            let cost = Ticktock.shared.convert(beginNano, end: endNano)
            print("[SwiftyJSON] - Cost is \(cost) ms")
        }
        print("finish")
    }
    
    private func encodeInClassicWay() -> String? {
        var ret: String?
        
        let model = simpleMode()
        
        // Step 1, convert object to dictionary
        var dictionary: [String: Any?] = [:]
        dictionary["age"] = model.age
        dictionary["cellphone"] = model.cellphone
        dictionary["id"] = model.id
        dictionary["sex"] = model.sex
        dictionary["name"] = model.name

        // Step 2, encode with API from Apple SDK
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("Can not convert to JSON String")
            return nil
        }

        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            ret = String(data:data, encoding: .utf8)
        }

        return ret
    }
    
    private func encodeWithCodale() -> String? {
        var ret: String?

        let model = simpleMode()
        do {
            ret = try model.jsonStr()
        } catch { }
        
        return ret
    }
    
    private func simpleMode() -> SimplePerson {
        var model = SimplePerson()
        model.age = 20
        model.cellphone = "13800000001"
        model.id = "110101200001010001"
        model.sex = "male"
        model.name = "Hello"
        return model
    }
    
    private func decodeWithCodable() -> Company? {
        var ret: Company?
        do {
            if let jsonData = decodeData() {
                ret = try Company.initialization(jsonData)
            }
        } catch {}
        return ret
    }

    private func decodeWithSwiftyJSON() -> Company {
        let ret = Company()
        let jsonString = decodeString()
        let json = JSON(parseJSON: jsonString)
        ret.identity = json["identity"].string
        ret.name = json["name"].string
        ret.location = json["location"].string
        if let teams = json["teams"].array {
            ret.teams = parseTeams(teams)
        }

        return ret
    }
    
    private func parseTeams(_ teams: [JSON]) -> [Team] {
        var ret: [Team] = []
        for item in teams {
            let team = Team()
            team.identity = item["identity"].string
            team.name = item["name"].string
            team.location = item["location"].string
            if let members = item["member"].array {
                team.members = parsePersons(members)
            }
            ret.append(team)
        }
        return ret
    }
    
    private func parsePersons(_ persons: [JSON]) -> [Person] {
        var ret: [Person] = []
        for item in persons {
            let person = Person()
            person.identity = item["identity"].string
            person.name = item["name"].string
            person.age = item["age"].int
            person.phone = item["phone"].string
            if let jobs = item["jobs"].array {
                person.jobs = parseJobs(jobs)
            }
            ret.append(person)
        }
        return ret
    }
    
    private func parseJobs(_ jobs: [JSON]) -> [Job] {
        var ret: [Job] = []
        for item in jobs {
            let job = Job()
            job.identity = item["identity"].string
            job.name = item["name"].string
            job.cost = item["cost"].int
            ret.append(job)
        }
        return ret
    }
    
    private func decodeString() -> String {
        var ret: String?
        if let path = Bundle.main.path(forResource: "codable", ofType: "json") {
            do {
                ret = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            } catch {}
        }
        return ret ?? ""
    }

    private func decodeData() -> Data? {
        var ret: Data?
        if let path = Bundle.main.path(forResource: "codable", ofType: "json") {
            do {
                ret = try Data(contentsOf: URL(fileURLWithPath: path))
            } catch {}
        }
        return ret
    }
}
