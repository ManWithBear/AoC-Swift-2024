import Algorithms
import RegexBuilder

struct Day13: AdventDay {

    struct Machine {
        var Y_a: Int
        var X_a: Int
        var Y_b: Int
        var X_b: Int
        var Y_p: Int
        var X_p: Int

        static func parse(data: String) -> Machine {
            let regex = Regex {
                "Button A: X+"
                Capture { OneOrMore(.digit) }
                ", Y+"
                Capture { OneOrMore(.digit) }
                "\nButton B: X+"
                Capture { OneOrMore(.digit) }
                ", Y+"
                Capture { OneOrMore(.digit) }
                "\nPrize: X="
                Capture { OneOrMore(.digit) }
                ", Y="
                Capture { OneOrMore(.digit) }
            }
            let matches = data.matches(of: regex)
            let Y_a = Int(matches[0].1)!
            let X_a = Int(matches[0].2)!
            let Y_b = Int(matches[0].3)!
            let X_b = Int(matches[0].4)!
            let Y_p = Int(matches[0].5)!
            let X_p = Int(matches[0].6)!
            return Machine(Y_a: Y_a, X_a: X_a, Y_b: Y_b, X_b: X_b, Y_p: Y_p, X_p: X_p)
        }

        func solveForA() -> Int {
            let a_numerator = Y_b * X_p - X_b * Y_p
            let a_denominator = Y_b * X_a - X_b * Y_a
            guard a_denominator != 0 else { return 0 }
            guard a_numerator.isMultiple(of: a_denominator) else { return 0 }
            let a = a_numerator / a_denominator
            let b_numerator = Y_a * X_p - X_a * Y_p
            let b_denominator = Y_a * X_b - X_a * Y_b
            guard b_denominator != 0 else { return 0 }
            guard b_numerator.isMultiple(of: b_denominator) else { return 0 }
            let b = b_numerator / b_denominator
            return a * 3 + b
        }

        func shiftForPart2() -> Self {
            var machine = self
            machine.X_p += 10_000_000_000_000
            machine.Y_p += 10_000_000_000_000
            return machine
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var machines: [Machine]

    init(data: String) {
        self.data = data
        self.machines = data.split(separator: "\n\n").map { Machine.parse(data: String($0)) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return machines.map { $0.solveForA() }.reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return machines.map { $0.shiftForPart2() }
            .map { $0.solveForA() }
            .reduce(0, +)
    }
}
