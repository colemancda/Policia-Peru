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
    
    public var serverURL: String = "http://consultas.mininter.gob.pe"
}