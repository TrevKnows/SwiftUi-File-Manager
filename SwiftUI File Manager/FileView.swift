//
//  FileView.swift
//  SwiftUI File Manager
//
//  Created by Trevor Beaton on 7/11/21.
//

import SwiftUI

struct FileView: View {
    @StateObject var model = ContentFileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(model.contentFiles) {
                        file in ContentFileRow(title: file.title)
                    }
                }
            }
        }.navigationTitle("File Contents")
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
    
    func gatherFiles() {
        
    }
    
}

struct ContentFile: Identifiable {
    var id = UUID()
    let title: String
    
}


struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView()
    }
}
