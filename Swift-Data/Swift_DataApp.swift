//
//  Swift_DataApp.swift
//  Swift-Data
//
//  Created by Parth Antala on 2024-07-12.
//

import SwiftUI
import SwiftData

@main
struct Swift_DataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
