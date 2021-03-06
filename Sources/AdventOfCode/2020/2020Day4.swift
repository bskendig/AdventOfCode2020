//
//  2020Day4.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

private let example1Input =
    """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """

private let example2InvalidInput =
    """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """

private let example2ValidInput =
    """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """

extension Dictionary where Key: StringProtocol, Value: StringProtocol {

    subscript(intKey key: Key) -> Int? {
        guard let value = self[key] else { return nil }

        guard value.count == 4 else {
            log("unexpected int length: \(value)")
            return nil
        }

        return Int(value)
    }

}

extension Year2020 {

    public enum Day4: PuzzleWithExample1 {

        public static let year: Year.Type = Year2020.self
        public static let day: Int = 4

        static func parsePassportLogEntry(
            _ passportLogEntry: String
        ) -> [String: String] {
            passportLogEntry
                .components(separatedBy: .whitespacesAndNewlines)
                .map { $0.components(separatedBy: ":") }
                .filter { $0.count == 2 }
                .map { ($0[0], $0[1]) }
                .reduce(into: [:]) { $0[$1.0] = $1.1 }
        }

        static func passportIsValidPart1(_ passport: [String: String]) -> Bool {
            Set(passport.keys).isSuperset(
                of: ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
            )
        }

        static func validate(
            key: String,
            range: ClosedRange<Int>,
            passport: [String: String]) -> Bool {
            guard let value = passport[intKey: key] else {
                log("missing \(key)")
                return false
            }

            guard range.contains(value) else {
                log("bad \(key): \(value)")
                return false
            }

            return true
        }

        static func validateHeight(in passport: [String: String]) -> Bool {
            guard let hgt = passport["hgt"],
                  let hgtValue = Scanner(string: hgt).scanInt()
            else { return false }

            if hgt.hasSuffix("in"), !(59...76).contains(hgtValue) {
                log("bad height (in): \(hgt)")
                return false
            }
            else if hgt.hasSuffix("cm"), !(150...193).contains(hgtValue) {
                log("bad height (cm): \(hgt)")
                return false
            }
            else if !(hgt.hasSuffix("in") || hgt.hasSuffix("cm")) {
                log("bad height: \(hgt)")
                return false
            }

            return true
        }

        static func passportIsValidPart2(_ passport: [String: String]) -> Bool {
            guard validate(key: "byr", range: 1920...2002, passport: passport),
                  validate(key: "iyr", range: 2010...2020, passport: passport),
                  validate(key: "eyr", range: 2020...2030, passport: passport),
                  validateHeight(in: passport)
            else { return false }

            guard let hcl = passport["hcl"],
                  hcl.count == 7,
                  hcl.hasPrefix("#")
            else { return false }

            let hclDigits = String(hcl[hcl.index(after: hcl.startIndex)...])

            if hclDigits.contains(where: { !($0.isLowercase || $0.isNumber) }) {
                return false
            }

            guard let ecl = passport["ecl"] else {
                log("missing ecl")
                return false
            }

            let validECLs = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

            guard validECLs.contains(ecl) else {
                log("bad ecl: \(ecl)")
                return false
            }

            guard let pid = passport["pid"],
                  pid.count == 9
            else {
                log("bad pid")
                return false
            }

            if pid.contains(where: { !$0.isNumber }) {
                log("bad pid: \(pid)")
                return false
            }

            return true
        }

        public static func example1() -> String {
            let input = parseInput(example1Input, separatedBy: "\n\n")
            let passports = input.map(parsePassportLogEntry)

            return "\(passports.count { passportIsValidPart1($0) })"
        }

        public static func part1() -> String {
            let input = parseInput(puzzleInput(), separatedBy: "\n\n")
            let passports = input.map(parsePassportLogEntry)

            return "\(passports.count { passportIsValidPart1($0) })"
        }

        public static func example2() {
            let invalid = parseInput(example2InvalidInput, separatedBy: "\n\n")
            let invalidPassports = invalid.map(parsePassportLogEntry)
            log(invalidPassports.count { passportIsValidPart2($0) })

            let valid = parseInput(example2ValidInput, separatedBy: "\n\n")
            let validPassports = valid.map(parsePassportLogEntry)
            log(validPassports.count { !passportIsValidPart2($0) })
        }

        public static func part2() -> String {
            let input = parseInput(puzzleInput(), separatedBy: "\n\n")
            let passports = input.map(parsePassportLogEntry)

            return "\(passports.count { passportIsValidPart2($0) })"
        }

    }

}
