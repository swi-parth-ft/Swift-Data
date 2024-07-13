//
//  ContentView.swift
//  Swift-Data
//
//  Created by Parth Antala on 2024-07-12.
//

import SwiftUI
import SwiftData

@Model
class User {
    var name: String
    var city: String
    var joinDate: Date

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> { user in
        if user.name.localizedStandardContains("R") {
            if user.city == "London" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
        ,sort: \User.name) var users: [User]
    
    
    var body: some View {
        NavigationStack() {
            List(users) { user in
                    Text(user.name)
                }
                .navigationTitle("Users")
            .toolbar {
                Button("Add Users", systemImage: "plus") {
                    try? modelContext.delete(model: User.self)
                    
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                                let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                                let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                                let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

                                modelContext.insert(first)
                                modelContext.insert(second)
                                modelContext.insert(third)
                                modelContext.insert(fourth)
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
