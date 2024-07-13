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
    @Relationship(deleteRule: .cascade) var jobs = [Job]()
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

@Model
class Job {
    var title: String
    var priority: Int
    var owner: User?
    
    init(title: String, priority: Int, owner: User? = nil) {
        self.title = title
        self.priority = priority
        self.owner = owner
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
    
    @State private var showUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    var body: some View {
        NavigationStack() {
            UserView(minimumJoinDate: showUpcomingOnly ? .now : .distantPast, sortDescriptor: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                    Button("Add Users", systemImage: "plus") {
                        try? modelContext.delete(model: User.self)
                        
                        let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                        let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                        let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                        let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                        
                        let job1 = Job(title: "Organize sock drawer", priority: 3)
                        let job2 = Job(title: "Make plans with Alex", priority: 4)
                        let job3 = Job(title: "Clean up kitchen", priority: 2)
                        
                        first.jobs.append(job1)
                        first.jobs.append(job2)
                        second.jobs.append(job3)
                        
                        modelContext.insert(first)
                        modelContext.insert(second)
                        modelContext.insert(third)
                        modelContext.insert(fourth)
                    }
                    
                    Button(showUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                        showUpcomingOnly.toggle()
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort By", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\User.name),
                                    SortDescriptor(\User.joinDate),
                                ])
                            
                            Text("Sort by join date")
                                .tag([
                                    SortDescriptor(\User.joinDate),
                                    SortDescriptor(\User.name),
                                ])
                        }
                    }
                }
        }
    }
}


struct UserView: View {
    @Query var users: [User]
    var body: some View {
        List(users) { user in
            HStack {
                   Text(user.name)

                   Spacer()

                   Text(String(user.jobs.count))
                       .fontWeight(.black)
                       .padding(.horizontal, 10)
                       .padding(.vertical, 5)
                       .background(.blue)
                       .foregroundStyle(.white)
                       .clipShape(.capsule)
               }
        }
    }
    
    init(minimumJoinDate: Date, sortDescriptor: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { $0.joinDate >= minimumJoinDate }, sort: sortDescriptor)
    }
}


#Preview {
    ContentView()
}
