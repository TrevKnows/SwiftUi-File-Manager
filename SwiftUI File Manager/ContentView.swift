//
//  ContentView.swift
//  SwiftUI File Manager
//
//  Created by Trevor Beaton on 7/5/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var model = ContentViewModel()
    
    @State var urlText = ""
    
    
    var body: some View {
        
        VStack{
            Spacer()
            Button("Make Directory") {
                model.makeFileDirectory()
            }
            .padding()
            
            
            
            Button("Create .py File") {
                model.createNewTextFile()
            }
            .padding()
            Button("Delete .py File") {
                model.deleteTextFile()
            }
            .padding()
            
        TextField("URL?", text: $urlText)
                .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            
            Button(action: {
                model.startDownload(urlString: urlText)
                
            }, label: {
                Text("Get Files")
                    .fontWeight(.semibold)
                    .padding(.vertical,10)
                    .padding(.horizontal,30)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            })
            .padding(.top)
            
            
            Spacer()
            VStack() {
                Text("Directory Path")
                Text(model.textRelay)
                
            }
            Text(model.textRelay)
            Spacer()
            
        }
        // Always on Light Mode.
        .preferredColorScheme(.light)
        
        .alert(isPresented: $model.showAlert, content: {
        
            Alert(title: Text("Message"),
                  message: Text(model.alertMsg),
                  dismissButton: .destructive(Text("Ok"),
                  action: {
                    
            }))
            
        })
        .overlay(
        
            ZStack {
                if model.showDownloadProgress {
                    DownloadProgressView(progress: $model.downloadProgress)
                        .environmentObject(model)
                }
            }
            
        )
        .onAppear(){
            model.startup()
            model.test()
            model.createMobileDirectory()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
