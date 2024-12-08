import Algorithms

struct Day07: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var calibrations: [(Int, [Int])]

    init(data: String) {
        self.data = data
        self.calibrations = data.split(separator: "\n").map {
            let split = $0.split(separator: ":", maxSplits: 1)
            let result = Int(split[0]) ?? 0
            let numbers = split[1].split(separator: " ").compactMap { Int($0) }
            return (result, numbers)
        }
    }

    func isCalibrationPossible(goal: Int, numbers: [Int]) -> Bool {
        var queue = [goal]
        for number in numbers.reversed() {
            queue = queue.flatMap { acc in
                var res = [Int]()
                if acc >= number {
                    res.append(acc - number)
                }
                if acc.isMultiple(of: number) {
                    res.append(acc / number)
                }
                return res
            }
            if queue.isEmpty {
                return false
            }
        }
        return queue.contains(0)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        calibrations
            .filter { isCalibrationPossible(goal: $0.0, numbers: $0.1) }
            .map { $0.0 }
            .reduce(0, +)
    }

    func unconcatenator(for number: Int) -> Int {
        String(number).reduce(1) { acc, _ in acc * 10 }
    }

    func isCalibrationPossibleWithConcatenation(goal: Int, numbers: [Int]) -> Bool {
        var queue = [goal]
        for number in numbers.reversed() {
            queue = queue.flatMap { acc in
                var res = [Int]()
                if acc >= number {
                    let sub = acc - number
                    res.append(sub)

                    let dividor = unconcatenator(for: number)
                    if sub.isMultiple(of: dividor) {
                        res.append(sub / dividor)
                    }
                }
                if acc.isMultiple(of: number) {
                    res.append(acc / number)
                }

                return res
            }
            if queue.isEmpty {
                return false
            }
        }
        return queue.contains(0)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        calibrations
            .filter { isCalibrationPossibleWithConcatenation(goal: $0.0, numbers: $0.1) }
            .map { $0.0 }
            .reduce(0, +)
    }
}
