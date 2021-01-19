//
//  DateFormatterExtension.swift
//  JournalCoreData
//
//  Created by Devin Flora on 1/18/21.
//

import Foundation

extension DateFormatter {
    
    static let entryTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
