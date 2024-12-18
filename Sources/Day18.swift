import Algorithms
import Collections

struct Day18: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    let size: Int
    let firstDrop: Int
    let start: Point
    let end: Point
    let drops: [Point]

    init(data: String) {
        self.init(data: data, size: 71, firstDrop: 1024)
    }

    init(data: String, size: Int, firstDrop: Int) {
        self.data = data
        self.size = size
        self.firstDrop = firstDrop
        self.start = Point(x: 0, y: 0)
        self.end = Point(x: size - 1, y: size - 1)
        self.drops = data.split(separator: "\n").map {
            let split = $0.split(separator: ",")
            return Point(x: Int(split[0])!, y: Int(split[1])!)
        }
    }

    func solve(grid: Grid<Int>) -> Int? {
        var grid = grid
        grid[start] = 1
        var queue = Deque<Point>([start])
        while let current = queue.popFirst() {
            for neighbor in current.neighbors4 {
                if grid[neighbor] == 0 {
                    grid[neighbor] = grid[current]! + 1
                    queue.append(neighbor)
                    if neighbor == end {
                        return grid[neighbor]! - 1
                    }
                }
            }
        }
        return nil
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var grid = Grid.emptySquare(of: size)
        for drop in drops.prefix(firstDrop) {
            grid[drop] = Int.max
        }
        return solve(grid: grid)!
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        var grid = Grid.emptySquare(of: size)
        for drop in drops.prefix(firstDrop) {
            grid[drop] = Int.max
        }
        for drop in drops.dropFirst(firstDrop) {
            grid[drop] = Int.max
            if solve(grid: grid) == nil {
                return "\(drop.x),\(drop.y)"
            }
        }
        return "-1"
    }
}
