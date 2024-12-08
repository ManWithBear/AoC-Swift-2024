import Algorithms

struct Point: Hashable {
    let x: Int
    let y: Int
}
extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

struct Day08: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var antennas: [Character: [Point]]
    var width: Int
    var height: Int

    init(data: String) {
        self.data = data
        antennas = [:]
        width = data.split(separator: "\n").first!.count
        height = data.split(separator: "\n").count
        for (y, line) in data.split(separator: "\n").enumerated() {
            for (x, char) in line.enumerated() {
                if char != "." {
                    antennas[char, default: []].append(Point(x: x, y: y))
                }
            }
        }
    }

    func isValid(point: Point) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let points = antennas.values.flatMap { points in
            return points.combinations(ofCount: 2).flatMap { pair in
                let dx = pair[0].x - pair[1].x
                let dy = pair[0].y - pair[1].y
                return [
                    Point(x: pair[0].x - dx, y: pair[0].y - dy),
                    Point(x: pair[0].x + dx, y: pair[0].y + dy),
                    Point(x: pair[1].x - dx, y: pair[1].y - dy),
                    Point(x: pair[1].x + dx, y: pair[1].y + dy),
                ]
                .filter { $0 != pair[0] && $0 != pair[1] }
                .filter { isValid(point: $0) }
            }
        }
        return Set(points).count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let points = antennas.values.flatMap { points in
            return points.combinations(ofCount: 2).flatMap { pair in
                let dx = pair[0].x - pair[1].x
                let dy = pair[0].y - pair[1].y
                var result = [pair[0]]
                var point = pair[0]
                while isValid(point: point) {
                    point = Point(x: point.x - dx, y: point.y - dy)
                    result.append(point)
                }
                point = pair[0]
                while isValid(point: point) {
                    point = Point(x: point.x + dx, y: point.y + dy)
                    result.append(point)
                }
                return result
            }
        }
        return Set(points).count { isValid(point: $0) }
    }
}
