//
//  Downloader.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import Foundation
@objc public class MOBFile : NSObject, URLSessionDownloadDelegate {
    internal static let mobileDefaultsStorageKey = "com.moballo.MOBFile"
    public static let downloadedFileKey = "MOBFileDownloadedFile-"
    internal let name: String
    internal let type: String
    internal let url: String
    internal let temporary: Bool
    internal let verificationString: String?
    internal let removeVerificationStrings: Bool
    public init(name: String, type: String, url: String, temporary: Bool = false, verificationString:String? = nil, removeVerificationStrings:Bool = false) {
        self.name = name
        self.type = type
        self.url = url
        self.temporary = temporary
        self.verificationString = verificationString
        self.removeVerificationStrings = removeVerificationStrings
        super.init()
    }
    public func download(expiresAfterDays: Int = 0, forceRedownload: Bool = false) {
        if (!self.temporary) {
            if let lastLoadedDate = UserDefaults.standard.object(forKey: self.downloadDateKey()) as! Date? , (forceRedownload == false && Swift.abs(lastLoadedDate.daysUntil(Date())) < expiresAfterDays) {
                if let lastVersionKey = UserDefaults.standard.string(forKey: self.downloadSoftwareVersionKey()), lastVersionKey == self.versionKey() {
                    return
                }
            }
        }
        if let url = self.address() {
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            let sessionConfig = URLSessionConfiguration.background(withIdentifier: "\(self.url)\(timestamp)")
            let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            let task = session.downloadTask(with: url)
            task.resume()
        }
    }
    public var path : URL? {
        if let path = getDownloadedFilePath() {
            return path
        } else if let path = Bundle.main.path(forResource: (self.nameOnLocal()), ofType: (self.type)) {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    internal func nameInDocuments(withExtension: Bool = false) -> String {
        if (withExtension) {
            if (!temporary) {
                return MOBFile.downloadedFileKey+name+"."+type
            } else {
                return name+"."+type
            }
        } else {
            if (!temporary) {
                return MOBFile.downloadedFileKey+name
            } else {
                return name
            }
        }
    }
    internal func address() -> URL? {
        if let out = URL(string: url) {
            return out
        }
        return nil
    }
    internal func nameOnLocal(withExtension: Bool = false) -> String {
        if (withExtension) {
            return name+"."+type
        } else {
            return name
        }
    }
    internal func downloadDateKey() -> String {
        return MOBFile.mobileDefaultsStorageKey + "." + self.nameInDocuments() + ".timestamp"
    }
    internal func downloadSoftwareVersionKey() -> String {
        return MOBFile.mobileDefaultsStorageKey + "." + self.nameInDocuments() + ".version"
    }
    internal func getDownloadedFilePath() -> URL? {
        if let lastVersionKey = UserDefaults.standard.string(forKey: self.downloadSoftwareVersionKey()) {
            if lastVersionKey != self.versionKey() {
                return nil
            }
        } else {
            return nil
        }
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let destinationUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(self.nameInDocuments(withExtension: true))
            if (FileManager.default.fileExists(atPath: destinationUrl.path)) {
                return destinationUrl
            }
        }
        return nil
    }
    
    //is called once the download is complete
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let destinationUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(self.nameInDocuments(withExtension: true))
            if let dataFromURL = try? Data(contentsOf: location) {
                var dataToWrite = dataFromURL
                do {
                    if let strungResponse = String(data: dataFromURL, encoding: String.Encoding.utf8) {
                        if strungResponse.contains("404 - File or directory not found.") {
                            print("MOBFile - INVALID DOWNLOAD - 404 Error - "+self.nameOnLocal())
                            downloadTask.cancel()
                            return
                        } else if strungResponse.contains("This page contains the following errors:") {
                            print("MOBFile - INVALID DOWNLOAD - Page contains errors - "+self.nameOnLocal())
                            downloadTask.cancel()
                            return
                        } else if strungResponse.removingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
                            print("MOBFile - INVALID DOWNLOAD - empty response - "+self.nameOnLocal())
                            downloadTask.cancel()
                            return
                        } else if let verificationString = self.verificationString {
                            if !(strungResponse as NSString).contains(verificationString) {
                                print("MOBFile - INVALID DOWNLOAD - Could not verify download - "+self.nameOnLocal())
                                downloadTask.cancel()
                                return
                            } else if removeVerificationStrings {
                                if let cleansed = strungResponse.replacingOccurrences(of: verificationString, with: "").data(using: String.Encoding.utf8) {
                                    dataToWrite = cleansed
                                }
                            }
                        }
                        //Fall through
                    }
                    
                    try dataToWrite.write(to: destinationUrl, options: [.atomic])
                    print("MOBFile - COMPLETED DOWNLOAD - "+self.nameOnLocal())
                }
                catch {
                    print("MOBFile - INVALID DOWNLOAD - Error writing downloaded file - "+self.nameOnLocal())
                }
                if (!self.temporary) {
                    UserDefaults.standard.set(self.versionKey(), forKey: self.downloadSoftwareVersionKey())
                    UserDefaults.standard.set(Date(), forKey: self.downloadDateKey())
                    UserDefaults.standard.synchronize()
                }
            }
        }
        downloadTask.cancel()
    }
    internal func versionKey() -> String {
        let actualAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let actualAppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        return (actualAppVersion + "-" + actualAppBuild)
    }
    //this is to track progress
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if(error != nil)
        {
            print("MOBFile - INVALID DOWNLOAD - Download completed with error: \(error!.localizedDescription) - "+self.nameOnLocal())
            task.cancel()
        }
    }
    public static func clearDocumentsDirectory() {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let filelist: [String]?
            do {
                filelist = try FileManager.default.contentsOfDirectory(atPath: dirPath)
                if filelist != nil {
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    for filename in filelist! {
                        let destinationUrl = documentsUrl!.appendingPathComponent(filename)
                        try FileManager.default.removeItem(at: destinationUrl)
                    }
                }
            } catch _ {}
        }
    }
    public static func cleanDocumentsDirectory() {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let filelist: [String]?
            do {
                filelist = try FileManager.default.contentsOfDirectory(atPath: dirPath)
                if filelist != nil {
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    for filename in filelist! {
                        if !filename.contains(MOBFile.downloadedFileKey) {
                            let destinationUrl = documentsUrl!.appendingPathComponent(filename)
                            try FileManager.default.removeItem(at: destinationUrl)
                        }
                    }
                }
            } catch _ {}
        }
    }
}
