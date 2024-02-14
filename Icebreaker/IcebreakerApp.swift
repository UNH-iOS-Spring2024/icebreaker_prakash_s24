//
//  IcebreakerApp.swift
//  Icebreaker
//
//  Created by Peter on 2/14/24.
//

import SwiftUI
import Firebase


@main
struct IcebreakerApp: App {
    init(){
           let providerFactory = AppCheckDebugProviderFactory()
           AppCheck.setAppCheckProviderFactory(providerFactory)
           
           FirebaseApp.configure()
       }
       
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
