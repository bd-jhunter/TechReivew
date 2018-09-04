//
//  Models.swift
//  TechViewCodable
//
//  Created by jhunter on 2018/8/22.
//  Copyright © 2018年 J.Hunter. All rights reserved.
//

import Foundation

class Job: CodableProtocol {
    var identity: String?
    var name: String?
    var cost: Int?
}

class Person: CodableProtocol {
    var identity: String?
    var name: String?
    var age: Int?
    var phone: String?
    var jobs: [Job]?
}

class Team: CodableProtocol {
    var identity: String?
    var name: String?
    var location: String?
    var members: [Person]?
}

class Company: CodableProtocol {
    var identity: String?
    var name: String?
    var location: String?
    var teams: [Team]?
}

class TestData {
    static let shared = TestData()
    
    func testModel() -> Company? {
        let company = Company()
        company.identity = "0001"
        company.name = "公司名称"
        company.location = "公司地址"
        company.teams = teams()
        
        return company
    }
    
    func teams() -> [Team] {
        var ret: [Team] = []
        for i in 1...7 {
            let team = Team()
            team.identity = String(format: "2%02ld", i)
            team.name = String(format: "团队: %03ld", i)
            team.location = String(format: "地址: %03ld", i)
            team.members = persons(baseIndex: i)
            ret.append(team)
        }
        
        return ret
    }
    
    func persons(baseIndex: Int) -> [Person] {
        var ret: [Person] = []
        for i in 1...10 {
            let person = Person()
            person.identity = String(format: "3%04ld", i + baseIndex)
            person.name = String(format: "人名: %03ld", baseIndex + i)
            person.age = 20
            person.phone = String(format: "13800000%03ld", baseIndex + i)
            jobs(forPerson: person)
            ret.append(person)
        }
        
        return ret
    }
    
    func jobs(forPerson person: Person) {
        var ret: [Job] = []
        var job = Job()
        job.cost = 100
        job.identity = "4001"
        job.name = "Job: 01"
        ret.append(job)
        job = Job()
        job.cost = 200
        job.identity = "4002"
        job.name = "Job: 02"
        ret.append(job)
        job = Job()
        job.cost = 300
        job.identity = "4003"
        job.name = "Job: 03"
        ret.append(job)

        person.jobs = ret
    }
    
    func testJSON() -> String? {
        var jsonString: String?
        if let path = Bundle.main.path(forResource: "codable", ofType: "json") {
            do {
                jsonString = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            } catch {
                print("Catch exception: \(error.localizedDescription)")
            }
        }
        return jsonString
    }
    
    func generateJSONFile() {
        if let company = testModel() {
            do {
                let jsonString = try company.jsonStr()
                try jsonString?.data(using: .utf8)?.write(to: URL(fileURLWithPath: "/Users/jhunter/codable.json"))
            } catch {}
        }
    }
}

struct SimplePerson: CodableProtocol {
    
    var id: String?
    var name: String?
    var age: Int?
    var sex: String?
    var cellphone: String?
}

