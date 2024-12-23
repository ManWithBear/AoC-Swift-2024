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

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
