//
//  Store.swift
//  Policia Peru
//
//  Created by Alsey Coleman Miller on 6/22/16.
//  Copyright © 2016 ColemanCDA. All rights reserved.
//

import SwiftFoundation


public class Store {
    
    public static let shared = Store()
    
    // MARK: - Properties
    
    /// The HTTP client that will be used to execute the requests to the server.
    public let client: HTTP.Client = HTTP.Client()
    
    /// The URL of the server.
    public var serverURL: String = "http://consultas.mininter.gob.pe"
    
    /// Request queue
    private let requestQueue: NSOperationQueue = {
        
        let queue = NSOperationQueue()
        
        queue.name = "\(Store.self) Request Queue"
        
        return queue
    }()
    
    // MARK: - Internal Methods
    
    /// Convenience function for adding a block to the request queue.
    internal func newRequest(block: () -> ()) {
        
        self.requestQueue.addOperationWithBlock(block)
    }
    
    internal func addHeaders(inout request: HTTP.Request) {
        
        request.headers["Content-Type"] = "application/json"
    }
    
    // MARK: Requests
    
    internal func getEntity<T: JSONDecodable>(request: HTTP.Request, completion: ErrorValue<T> -> ()) {
        
        /// **Get Entity** parsing method
        func parse(response: HTTP.Response) throws -> T  {
            
            guard response.statusCode == HTTP.StatusCode.OK.rawValue
                else { throw Error.ErrorStatusCode(response.statusCode) }
            
            guard let jsonString = String(UTF8Data: response.body),
                let json = JSON.Value(string: jsonString),
                let entity = T(JSONValue: json)
                else { throw Error.InvalidResponse }
            
            return entity
        }
        
        // execute request
        newRequest {
            
            let entity: T
            
            do {
                let response = try self.client.sendRequest(request)
                
                entity = try parse(response)
            }
                
            catch { mainQueue { completion(.Error(error)) }; return }
            
            mainQueue { completion(.Value(entity)) }
        }
    }
}

// MARK: - Private Functions

/// Convenience function for adding a block to the main queue.
internal func mainQueue(block: () -> ()) {
    
    NSOperationQueue.mainQueue().addOperationWithBlock(block)
}

// MARK: - Supporting Types

/// Basic wrapper for error / value pairs.
public enum ErrorValue<T> {
    
    case Error(ErrorType)
    case Value(T)
}

public extension Store {
    
    public enum Error: ErrorType {
        
        /// The server returned a status code indicating an error.
        case ErrorStatusCode(Int)
        
        /// The server returned an invalid response.
        case InvalidResponse
        
        /// A custom error from the server.
        case CustomServerError(String)
    }
}