import Algorithms

struct Day14: AdventDay {
    struct Robot {
        var x: Int
        var y: Int
        var vx: Int
        var vy: Int

        static func parse(data: String) -> Self {
            let regex = /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/
            let match = data.matches(of: regex)
            return Self(
                x: Int(match[0].1)!,
                y: Int(match[0].2)!,
                vx: Int(match[0].3)!,
                vy: Int(match[0].4)!
            )
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var width: Int
    var height: Int
    var robots: [Robot]

    init(data: String) {
        self.init(data: data, width: 101, height: 103)
    }

    init(data: String, width: Int, height: Int) {
        self.data = data
        self.width = width
        self.height = height
        self.robots = data.split(separator: "\n").map { Robot.parse(data: String($0)) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let X1 = 0..<(width / 2)
        let X2 = (width / 2 + 1)..<width
        let Y1 = 0..<(height / 2)
        let Y2 = (height / 2 + 1)..<height
        var s11 = 0
        var s12 = 0
        var s21 = 0
        var s22 = 0

        for robot in robots {
            let x = (robot.x + 100 * (robot.vx + width)) % width
            let y = (robot.y + 100 * (robot.vy + height)) % height
            switch (x, y) {
            case (X1, Y1): s11 += 1
            case (X1, Y2): s12 += 1
            case (X2, Y1): s21 += 1
            case (X2, Y2): s22 += 1
            default:
                continue
            }
        }
        return s11 * s22 * s12 * s21
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        for i in 0..<10000 {
            var points: Set<Point> = []
            for robot in robots {
                let x = (robot.x + i * (robot.vx + width)) % width
                let y = (robot.y + i * (robot.vy + height)) % height
                points.insert(Point(x: x, y: y))
            }

            for point in points {
                let x = point.x
                let y = point.y
                // ...#...
                // ..###..
                // .#####.
                let treeTop = Set([
                    Point(x: x - 1, y: y + 1), Point(x: x, y: y + 1), Point(x: x + 1, y: y + 1),
                    Point(x: x - 2, y: y + 2), Point(x: x - 1, y: y + 2), Point(x: x, y: y + 2),
                    Point(x: x + 2, y: y + 2), Point(x: x + 2, y: y + 2),
                ])
                var visualization: String = ""
                if treeTop.isSubset(of: points) {
                    for y in 0..<height {
                        for x in 0..<width {
                            if points.contains(Point(x: x, y: y)) {
                                visualization += "#"
                            } else {
                                visualization += "."
                            }
                        }
                        visualization += "\n"
                    }
                    // print(visualization)
                    return i
                }
            }
        }
        return -1
    }
}
