//
//  HTTPURLResponse.swift
//  Gratitude
//
//  Created by Yuvaraj on 24/09/22.
//

import Foundation

extension HTTPURLResponse {
    var isInformational: Bool {
        return (100...199).contains(self.statusCode)
    }
    
    var isOK: Bool {
        return (200...299).contains(self.statusCode)
    }
    
    var isRedirected: Bool {
        return (300...399).contains(self.statusCode)
    }
    
    var isClientIssue: Bool {
        return (400...499).contains(self.statusCode)
    }
    
    var isServerIssue: Bool {
        return (500...599).contains(self.statusCode)
    }
}
