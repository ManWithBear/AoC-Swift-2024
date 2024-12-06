import Algorithms

enum Cell: Character {
    case empty = "."
    case wall = "#"
    case visited = "X"
}
enum Direction: Character {
    case north = "^"
    case east = ">"
    case south = "v"
    case west = "<"

    func turnRight() -> Direction {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }
    func step(from: (y: Int, x: Int)) -> (y: Int, x: Int) {
        switch self {
        case .north: return (from.y - 1, from.x)
        case .east: return (from.y, from.x + 1)
        case .south: return (from.y + 1, from.x)
        case .west: return (from.y, from.x - 1)
        }
    }
}

final class Day06: @unchecked Sendable, AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var grid: [[Cell]]
    var direction: Direction
    var guardPosition: (y: Int, x: Int) = (0, 0)
    var height: Int
    var width: Int

    init(data: String) {
        self.data = data
        var direction = Direction.north
        self.grid = data.split(separator: "\n").map {
            $0.map {
                guard let cell = Cell(rawValue: $0) else {
                    direction = Direction(rawValue: $0)!
                    return .visited
                }
                return cell
            }
        }
        self.direction = direction
        self.height = grid.count
        self.width = grid[0].count
        loop: for y in 0..<height {
            for x in 0..<width {
                if grid[y][x] == .visited {
                    self.guardPosition = (y, x)
                    break loop
                }
            }
        }
    }

    func canStep(to: (y: Int, x: Int)) -> Bool {
        grid[to.y][to.x] != .wall
    }
    func isOutOfBounds(_ position: (y: Int, x: Int)) -> Bool {
        position.y < 0 || position.y >= height || position.x < 0 || position.x >= width
    }

    func countVisitedCells() -> Int {
        grid.map { $0.count { $0 == .visited } }
            .reduce(0, +)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        while true {
            let nextPosition = direction.step(from: guardPosition)
            if isOutOfBounds(nextPosition) {
                print("Out of bounds, [\(nextPosition.x), \(nextPosition.y)]")
                break
            }
            if canStep(to: nextPosition) {
                guardPosition = nextPosition
                grid[guardPosition.y][guardPosition.x] = .visited
            } else {
                direction = direction.turnRight()
            }
        }
        return countVisitedCells()
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
