import Algorithms

struct Day21: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var codes: [String]
    var numericCodes: [Int]
    var numberKeypad: [Character: Point] = [
        "7": Point(x: 0, y: 0),
        "8": Point(x: 1, y: 0),
        "9": Point(x: 2, y: 0),
        "4": Point(x: 0, y: 1),
        "5": Point(x: 1, y: 1),
        "6": Point(x: 2, y: 1),
        "1": Point(x: 0, y: 2),
        "2": Point(x: 1, y: 2),
        "3": Point(x: 2, y: 2),
        "0": Point(x: 1, y: 3),
        "A": Point(x: 2, y: 3),
    ]
    var directionalKeypad: [Character: Point] = [
        "^": Point(x: 1, y: 0),
        "A": Point(x: 2, y: 0),
        "<": Point(x: 0, y: 1),
        "v": Point(x: 1, y: 1),
        ">": Point(x: 2, y: 1),
    ]

    init(data: String) {
        self.data = data
        self.codes = data.split(separator: "\n").map { String($0) }
        self.numericCodes = codes.map { Int($0.dropLast())! }
    }

    func type(code: String, on keypad: [Character: Point], deadZone: Point) -> Set<String> {
        var lastPoint = keypad["A"]!
        var result: Set<String> = [""]
        for character in code {
            let point = keypad[character]!
            let delta = point - lastPoint
            let horizontalChar = delta.x < 0 ? "<" : ">"
            let horizontal = String(repeating: horizontalChar, count: abs(delta.x))
            let verticalChar = delta.y < 0 ? "^" : "v"
            let vertical = String(repeating: verticalChar, count: abs(delta.y))
            var newResults: Set<String> = []
            let hitDeadZoneWhenMovingVertically = lastPoint.x == deadZone.x && point.y == deadZone.y
            let hitDeadZoneWhenMovingHorizontally =
                lastPoint.y == deadZone.y && point.x == deadZone.x
            if !hitDeadZoneWhenMovingVertically {
                newResults.formUnion(result.map { $0 + vertical + horizontal + "A" })
            }
            if !hitDeadZoneWhenMovingHorizontally {
                newResults.formUnion(result.map { $0 + horizontal + vertical + "A" })
            }
            result = newResults
            lastPoint = point
        }
        return result
    }

    func part1() -> Any {
        let commands = codes.map { type(code: $0, on: numberKeypad, deadZone: Point(x: 0, y: 3)) }
            .map {
                $0.unionMap { type(code: $0, on: directionalKeypad, deadZone: Point(x: 0, y: 0)) }
            }
            .map {
                $0.unionMap { type(code: $0, on: directionalKeypad, deadZone: Point(x: 0, y: 0)) }
            }
            .map { $0.min { $0.count < $1.count }! }
        return zip(numericCodes, commands)
            .map { $0 * $1.count }
            .reduce(0, +)
    }

    func typeNumerical(code: String) -> [[String: Int]] {
        let deadZone = Point(x: 0, y: 3)
        var lastPoint = numberKeypad["A"]!
        var results: [[String: Int]] = [[:]]
        for character in code {
            let point = numberKeypad[character]!
            let delta = point - lastPoint
            let horizontalChar = delta.x < 0 ? "<" : ">"
            let horizontal = String(repeating: horizontalChar, count: abs(delta.x))
            let verticalChar = delta.y < 0 ? "^" : "v"
            let vertical = String(repeating: verticalChar, count: abs(delta.y))
            var newResults: [[String: Int]] = []
            let hitDeadZoneWhenMovingVertically = lastPoint.x == deadZone.x && point.y == deadZone.y
            let hitDeadZoneWhenMovingHorizontally =
                lastPoint.y == deadZone.y && point.x == deadZone.x
            if !hitDeadZoneWhenMovingVertically {
                newResults += results.map {
                    var dict = $0
                    dict[vertical + horizontal + "A", default: 0] += 1
                    return dict
                }
            }
            if !hitDeadZoneWhenMovingHorizontally {
                newResults += results.map {
                    var dict = $0
                    dict[horizontal + vertical + "A", default: 0] += 1
                    return dict
                }
            }
            results = newResults
            lastPoint = point
        }
        return results
    }

    nonisolated(unsafe) static var memo: [String: [String: Int]] = [:]
    func typeDirectional(code: String) -> [String: Int] {
        if let res = Self.memo[code] {
            return res
        }
        var lastPoint = directionalKeypad["A"]!
        var result: [String: Int] = [:]
        for character in code {
            let point = directionalKeypad[character]!
            defer { lastPoint = point }
            let delta = point - lastPoint
            let horizontalChar = delta.x < 0 ? "<" : ">"
            let horizontal = String(repeating: horizontalChar, count: abs(delta.x))
            let verticalChar = delta.y < 0 ? "^" : "v"
            let vertical = String(repeating: verticalChar, count: abs(delta.y))

            if lastPoint == Point(x: 0, y: 1) {
                result[horizontal + vertical + "A", default: 0] += 1
                continue
            }
            if character == "<" {
                result[vertical + horizontal + "A", default: 0] += 1
                continue
            }
            // https://www.reddit.com/r/adventofcode/comments/1hjgyps/2024_day_21_part_2_i_got_greedyish/
            // I was lazy to check this rules myself
            switch (delta.x, delta.y) {
            case (_, 0), (0, _):
                result[horizontal + vertical + "A", default: 0] += 1
            case (..<0, ..<0):  // up-left
                result[horizontal + vertical + "A", default: 0] += 1
            case (..<0, 1...):  // down-left
                result[horizontal + vertical + "A", default: 0] += 1
            case (1..., 1...):  // down-right
                result[vertical + horizontal + "A", default: 0] += 1
            case (1..., ..<0):  // up-right
                result[vertical + horizontal + "A", default: 0] += 1
            default:
                fatalError("It's impossible")
            }
        }
        Self.memo[code] = result
        return result
    }

    func part2() -> Any {
        var sum = 0
        for (code, number) in zip(codes, numericCodes) {
            let length = typeNumerical(code: code).map { commands in
                var commands = commands
                for _ in 0..<25 {
                    var newCommands: [String: Int] = [:]
                    for (command, count) in commands {
                        let d = typeDirectional(code: command)
                        for (key, value) in d {
                            newCommands[key, default: 0] += value * count
                        }
                    }
                    commands = newCommands
                }
                return commands
            }
            .map { $0.reduce(0) { $0 + $1.key.count * $1.value } }
            .min()!
            sum += number * length
        }
        return sum
    }
}
