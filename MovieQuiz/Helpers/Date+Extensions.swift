//
//  Date+Extensions.swift
//  MovieQuiz
//
//  Created by Nurbol on 23.06.2024.
//

import Foundation

extension Date {
    private var dateTimeDefaultFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY hh:mm"
        return dateFormatter
    }
    
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}
