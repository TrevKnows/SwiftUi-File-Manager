//
//  FileViewModel.swift
//  SwiftUI File Manager
//
//  Created by Trevor Beaton on 7/11/21.
//

import SwiftUI
import Zip


class FileViewModel: ObservableObject {
    
    @Published var fileArray: [ContentFile] = []
    
    let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let cachesPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    func startup(){
        print("Directory Path: \(directoryPath.path)")
        print("Caches Directory Path: \(cachesPath.path)")
        
        var fileSize : UInt64 = 0

        
        do {
            
            let contents = try FileManager.default.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: nil,options: [.skipsHiddenFiles])
            
            
            let attr = try FileManager.default.attributesOfItem(atPath: directoryPath.path)
                        fileSize = attr[FileAttributeKey.size] as! UInt64
                         
                        let dict = attr as NSDictionary
                        fileSize = dict.fileSize()

            for i in attr {
                print("File Size: \(i.value)")
            }
            
            
            for file in contents {
                print("File Content: \(file.lastPathComponent)")
              //  print("File Size: \(fileSize)")
                
               let addedFile = ContentFile(title: file.lastPathComponent)
                self.fileArray.append(addedFile)
            }
        } catch {
            print("Error: \(error)")
        }
        
        
        
        
    }
    
    
    
    
    
}
