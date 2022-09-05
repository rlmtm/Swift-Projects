//
//  ViewController.swift
//  UsingFiles
//
//  Created by MILLER, Maximilian on 04.09.22.
//


import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController {
    
    @IBAction func writeFiles(_ sender: Any) {
        
        let file = "\(UUID().uuidString).txt"
        let contents = "Some text..."
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(file)
        
        do {
            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func importItemFromFiles(sender: UIBarButtonItem) {

             var documentPicker: UIDocumentPickerViewController!
             if #available(iOS 14, *) {
                 // iOS 14 & later
                 let supportedTypes: [UTType] = [UTType.image]
                 documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
             } else {
                 // iOS 13 or older code
                 let supportedTypes: [String] = [kUTTypeImage as String]
                 documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
             }
             documentPicker.delegate = self
             documentPicker.allowsMultipleSelection = true
             documentPicker.modalPresentationStyle = .formSheet
             self.present(documentPicker, animated: true)
         }
}

extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
        }
        else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}
