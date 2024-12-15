import Algorithms

struct Day10: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var heights: [[Int]]
    var width: Int
    var height: Int

    init(data: String) {
        self.data = data
        let heights = data.split(separator: "\n").map { line in
            line.map { Int(String($0))! }
        }
        self.heights = heights
        width = heights[0].count
        height = heights.count
    }

    func isValid(point: Point) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }
    func getTopNeighbour(for point: Point) -> Point? {
        let top = Point(x: point.x, y: point.y - 1)
        return isValid(point: top) ? top : nil
    }
    func getBottomNeighbour(for point: Point) -> Point? {
        let bottom = Point(x: point.x, y: point.y + 1)
        return isValid(point: bottom) ? bottom : nil
    }
    func getLeftNeighbour(for point: Point) -> Point? {
        let left = Point(x: point.x - 1, y: point.y)
        return isValid(point: left) ? left : nil
    }
    func getRightNeighbour(for point: Point) -> Point? {
        let right = Point(x: point.x + 1, y: point.y)
        return isValid(point: right) ? right : nil
    }
    func height(for point: Point) -> Int {
        heights[point.y][point.x]
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var reachableFromPoint: [Point: Set<Point>] = [:]
        var visited: Set<Point> = []
        var zeroes: Set<Point> = []
        for y in 0..<height {
            for x in 0..<width {
                let point = Point(x: x, y: y)
                if height(for: point) == 9 {
                    visited.insert(point)
                    reachableFromPoint[point] = Set([point])
                }
                if height(for: point) == 0 {
                    zeroes.insert(point)
                }
            }
        }
        while !visited.isEmpty {
            let point = visited.removeFirst()
            let pointHeight = height(for: point)
            let reachable = reachableFromPoint[point]!
            func check(neighbour: Point?) {
                guard let neighbour = neighbour else { return }
                if height(for: neighbour) + 1 == pointHeight {
                    reachableFromPoint[neighbour, default: Set()].formUnion(reachable)
                    if height != 1 {
                        // no need to visit the end points (0)
                        visited.insert(neighbour)
                    }
                }
            }
            check(neighbour: getTopNeighbour(for: point))
            check(neighbour: getBottomNeighbour(for: point))
            check(neighbour: getLeftNeighbour(for: point))
            check(neighbour: getRightNeighbour(for: point))
        }
        return zeroes.map { reachableFromPoint[$0]!.count }.reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
