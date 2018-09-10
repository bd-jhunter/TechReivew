//
//  Person+CoreDataProperties.swift
//  
//
//  Created by jhunter on 2018/9/7.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func personFetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var address: String?
    @NSManaged public var gender: Bool
    @NSManaged public var id: Int64
    @NSManaged public var cellphone: String?

}
