struct Day13: AdventDay {
    struct Machine {
        var Y_a, X_a, Y_b, X_b, Y_p, X_p: Int
        static func parse(data: String) -> Machine {
            let regex =
                /Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/
            let matches = data.matches(of: regex)
            return Machine(
                Y_a: Int(matches[0].1)!, X_a: Int(matches[0].2)!,
                Y_b: Int(matches[0].3)!, X_b: Int(matches[0].4)!,
                Y_p: Int(matches[0].5)!, X_p: Int(matches[0].6)!
            )
        }
        func solveForA() -> Int {
            let a_numerator = Y_b * X_p - X_b * Y_p
            let a_denominator = Y_b * X_a - X_b * Y_a
            guard a_denominator != 0, a_numerator.isMultiple(of: a_denominator) else { return 0 }
            let a = a_numerator / a_denominator
            let b_numerator = X_p - X_a * a
            guard X_b != 0, b_numerator.isMultiple(of: X_b) else { return 0 }
            return a * 3 + (b_numerator / X_b)
        }
        func shiftForPart2() -> Self {
            var machine = self
            machine.X_p += 10_000_000_000_000
            machine.Y_p += 10_000_000_000_000
            return machine
        }
    }
    var machines: [Machine]
    init(data: String) {
        self.machines = data.split(separator: "\n\n").map { Machine.parse(data: String($0)) }
    }
    func part1() -> Any {
        return machines.map { $0.solveForA() }.reduce(0, +)
    }
    func part2() -> Any {
        return machines.map { $0.shiftForPart2() }.map { $0.solveForA() }.reduce(0, +)
    }
}
