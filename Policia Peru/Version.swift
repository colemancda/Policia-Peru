//
//  Version.swift
//  Policia Peru
//
//  Created by Alsey Coleman Miller on 6/21/16.
//  Copyright © 2016 ColemanCDA. All rights reserved.
//

import Foundation

/** Version of the app. */
public let AppVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String

/** Build of the app. */
public let AppBuild = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String