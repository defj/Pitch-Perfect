//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Joshua Gan on 14/03/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
