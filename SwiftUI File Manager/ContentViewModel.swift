//
//  ContentViewModel.swift
//  SwiftUI File Manager
//
//  Created by Trevor Beaton on 7/5/21.
//

import SwiftUI
import Zip


class ContentViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
    
    
    
    let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // For Downloads
    @Published var downloadURL: URL!
    
    // Progress...
    @Published var downloadProgress: CGFloat = 0
    
    // Alert
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    // Show Progress View
    @Published var showDownloadProgress = false
    
    @Published var textRelay = ""
    
    // Saving Download task reference for cancelling...
    @Published var downloadTaskSession: URLSessionDownloadTask!
    

    
    func readContents() {
        
        let path = Bundle.main.resourcePath!
        
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: path)
            
            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    
    
    // Cancel Task
    func cancelTask() {
        
    }
    
    
    func createMobileDirectory() {
        
        // Give directory head string location
        let stringURL = directoryPath.absoluteString
        
        do {
            try FileManager.default.createDirectory(at: directoryPath,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            
            
            // Holds a list of URL
            let contents = try FileManager.default.contentsOfDirectory(at: directoryPath,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles])
            
            //  try FileManager.default.contents(atPath: directoryURL.absoluteString)
            
            //   let attributes =
            try FileManager.default.attributesOfItem(atPath: directoryPath.path)
            
            //     let creationDate = attributes[.creationDate]
            
            
            for file in contents {
                // textRelay.appending(file.absoluteString)
                //print("File Found: \(file.absoluteString)")
                print("Last Path Component: \(file.lastPathComponent)")
                let newFile = ContentFile(title: file.lastPathComponent)
                //   contentModel.fileArray.append(newFile)
            }
            
        }
        catch {
            print("Error: \(error)")
        }
        
        textRelay = stringURL
        
    }
    
    
    
    // MARK:- Download
    func startDownload(urlString: String){
        
        // Check for valid URL
        guard let validURL = URL(string: urlString) else {
            self.reportError(error: "Invalid URL!")
            return
        }
        downloadProgress = 0
        withAnimation{showDownloadProgress = true}
        
        // Download Task...
        // Since were going to get the progress as well as location of the File, I'm going to use a delegate...
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        downloadTaskSession = session.downloadTask(with: validURL)
        downloadTaskSession.resume()
    }
    
    // Report Error Function...
    func reportError(error: String){
        alertMsg = error
        showAlert.toggle()
    }
    
    
    func startup(){
        let manager = FileManager.default
        
        guard let url = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {return}
        
        print("Directory Path: \(directoryPath.path)")
    }
    
    func makeFileDirectory() {
        // Creating a File Manager Object
        let manager = FileManager.default
        
        // Creating a path to make a document directory path
        guard let url = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {return}
        print(url.path)
        // Creating a folder
        let pyleapProjectFolderURL = url.appendingPathComponent("PyLeap Folder0")
        
        do {
            
            try manager.createDirectory(at: pyleapProjectFolderURL,
                                        withIntermediateDirectories: true,
                                        attributes: [:])
        } catch {
            print(error)
        }
    }
    
    
    
    
    func test() {
        print("Test Func called")
        let CPZipName = directoryPath.appendingPathComponent("CP2.zip")
        
        let pyleapProjectFile = directoryPath.appendingPathComponent("PyLeap Folder")
        
        // Download Site...
        let urlString = "https://learn.adafruit.com/pages/22555/elements/3098569/download?type=zip"
        
        
        if let zipFileUrl = URL(string: urlString) {
            // Download from this site
            URLSession.shared.downloadTask(with: zipFileUrl) { (tempFileUrl, response, error) in
                
                /*
                 if let...
                 if you can let the new variable name equal the non-optional version of optionalName, do the following with it"
                 */
                
                if let zipTempFileUrl = tempFileUrl {
                    do {
                        
                        let zipData = try Data(contentsOf: zipTempFileUrl)
                        
                        try zipData.write(to: CPZipName)
                        
                        let unzipDirectory = try Zip.quickUnzipFile(CPZipName) // Unzip
                        
                        try FileManager.default.removeItem(at: CPZipName)
                        
                    } catch {
                        print("Error: \(error)")            
                    }
                }
            }.resume()
        }
    }
    
    func createNewTextFile() {
        
        // Creating a File Manager Object
        let manager = FileManager.default
        
        // Creating a path to make a document directory path
        guard let url = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {return}
        
        // Creating a folder
        let newFolderURL = url.appendingPathComponent("PyLeap Folder")
        
        let textFile = newFolderURL.appendingPathComponent("testLog.py")
        
        let data = "Hey! This is a test!".data(using: .utf8)
        
        manager.createFile(atPath: textFile.path,
                           contents: data,
                           attributes: [FileAttributeKey.creationDate:Date()])
        
    }
    
    
    func deleteTextFile() {
        
        // Creating a File Manager Object
        let manager = FileManager.default
        
        guard let url = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {return}
        
        let newFolderURL = url.appendingPathComponent("PyLeap Folder")
        
        let textFile = newFolderURL.appendingPathComponent("testLog.py")
        
        if manager.fileExists(atPath: textFile.path) {
            print("this is a thing on a disk")
            
            do {
                try manager.removeItem(at: textFile)
                
            } catch {
                print(error)
            }
            
        }
    }
    
    
    func deleteExistingFolder() {
        
        let manager = FileManager.default
        
        guard let url = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {return}
        
        let newFolderURL = url.appendingPathComponent("New_Folder")
        
        if manager.fileExists(atPath: newFolderURL.path) {
            
            do {
                try manager.removeItem(at: newFolderURL)
                
            } catch {
                print(error)
            }
        }
    }
    
    
    /// Tells the delegate that a download task has finished downloading.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(location)
        
        guard let url = downloadTask.originalRequest?.url else {
            self.reportError(error: "An error has occurred...")
            return
        }
        
        
        
        // Creating a destination for storing files with a destination URL
        let destinationURL = directoryPath.appendingPathComponent(url.lastPathComponent)
        
        //if that file already exists, replace it.
        
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            
            // Copy temp file to directory.
            try FileManager.default.copyItem(at: location, to: destinationURL)
            
            // If Success
            print("Success")
            readContents()
            // Closing Progress View
            DispatchQueue.main.async {
                withAnimation{self.showDownloadProgress = false}
            }
            
            
        } catch {
            print(error)
            self.reportError(error: "Try again later")
        }
        
    }
    
    /// Periodically informs the delegate about the download’s progress - Used for progress UI
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // Getting Progress
        let numeralProgress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print("Progress: \(numeralProgress)")
        
        // Since URL Session will be running in the background thread
        // UI will be done on the main thread
        DispatchQueue.main.async {
            self.downloadProgress = numeralProgress
        }
    }
    
    
}


