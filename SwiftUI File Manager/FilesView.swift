//
//  FileView.swift
//  SwiftUI File Manager
//
//  Created by Trevor Beaton on 7/11/21.
//

import SwiftUI

struct FilesView: View {
    
    @StateObject var downloadModel = DownloadViewModel()
    @StateObject var fvmodel = FileViewModel()
    
    
    let downloadLink: String = "https://learn.adafruit.com/pages/22555/elements/3098569/download?type=zip"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Text("Connected to : nil")
                    Spacer()
                }
                
                List {
                    Section(header: Text("Project Folders")) {
                        ForEach(fvmodel.fileArray) {
                            file in
                            ContentFileRow(title: file.title)
                            
                        }
                    }
                }
                
                
                HStack {
                    // Bottom
                    Button(action: {
                        //downloadModel.startDownload(urlString: downloadLink)
                        downloadModel.unzipProjectFile()
                    }, label: {
                        Text("Gather Bundle")
                            .fontWeight(.semibold)
                            .padding(.vertical,10)
                            .padding(.horizontal,30)
                            .background(Color(#colorLiteral(red: 0.7267638319, green: 0.521538479, blue: 1, alpha: 1)))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    })
                    .padding(.top)
                    
                    
                    Button(action: {
                        //downloadModel.startDownload(urlString: downloadLink)
                        downloadModel.unzipProjectFile()
                    }, label: {
                        Text("Send Bundle")
                            .fontWeight(.semibold)
                            .padding(.vertical,10)
                            .padding(.horizontal,30)
                            .background(Color(#colorLiteral(red: 0.7267638319, green: 0.521538479, blue: 1, alpha: 1)))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    })
                    .padding(.top)
                    
                }
                
                Button(action: {
                    //downloadModel.startDownload(urlString: downloadLink)
                    downloadModel.deleteTextFile()
                }, label: {
                    Text("Delete Bundle")
                        .fontWeight(.semibold)
                        .padding(.vertical,10)
                        .padding(.horizontal,30)
                        .background(Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                .padding(.top)
                
                
                
            }
            .navigationTitle("App Directory")
            .onAppear(){
                //   OGmodel.startup()
                // OGmodel.test()
                // downloadModel.makeFileDirectory()
                //  downloadModel.createNewTextFile()
                // downloadModel.startDownload(urlString: downloadLink)
                downloadModel.startup()
                downloadModel.makeFileDirectory()
                downloadModel.unzipProjectFile()
                fvmodel.startup()
                
            }
        }
        
    }
    
}


struct ContentFileRow: View {
    let title : String
    
    var body: some View {
        Label(
            title: { Text(title) },
            icon: { Image(systemName: "doc.text") })
    }
}



class ContentFileViewModel: ObservableObject {
    @Published var contentFiles = [ContentFile]()
    
    @Published var fileArray: [ContentFile] = [
        ContentFile(title: "Test")
    ]
    
    func gatherFiles() {
        
    }
    
}

struct ContentFile: Identifiable {
    var id = UUID()
    let title: String
    
}


struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
