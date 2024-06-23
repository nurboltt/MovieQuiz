//
//  Array+Extension.swift
//  MovieQuiz
//
//  Created by Nurbol on 23.06.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
