//
//  CollectionAlgorithms.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension Sequence where Element: Equatable {

    func containsAny<T: Sequence>(
        in otherSequence: T
    ) -> Bool where T.Element == Element {
        for element in otherSequence {
            if self.contains(element) {
                return true
            }
        }

        return false
    }

}

extension StringProtocol {

    func containsAny<T: StringProtocol>(in strings: [T]) -> Bool {
        for string in strings {
            if self.contains(string) {
                return true
            }
        }

        return false
    }

}

extension Sequence {

    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }

    func sum<T>(
        _ transform: (Element) throws -> T
    ) rethrows -> T where T: AdditiveArithmetic {
        try map(transform).sum()
    }

}

extension Sequence where Element: AdditiveArithmetic {

    func sum() -> Element {
        reduce(.zero, +)
    }

}
