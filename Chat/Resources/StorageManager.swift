//
//  StorageManager.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public typealias UploadPhotoCompletition = (Result<String, Error>) -> Void
    
    
    /// Upload picture to Google Firebase Storage
    public func uploadProfilePhoto(with data: Data, fileName: String, completion: @escaping UploadPhotoCompletition) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                completion(.failure(StorageError.uploadFailed))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    completion(.failure(StorageError.downloadURLFailed))
                    return
                }
                
                let urlString = url.absoluteString
                print("\(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageError : Error {
        case uploadFailed
        case downloadURLFailed
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.downloadURLFailed))
                return
            }
            completion(.success(url))
        })
    }
}
