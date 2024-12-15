import Algorithms

enum WarehouseCell: Character, Equatable {
    case wall = "#"
    case empty = "."
    case box = "O"
    case robot = "@"
}

struct Day15: AdventDay {
    struct Warehouse {
        var grid: Grid<WarehouseCell>
        var robot: Point = .zero

        mutating func move(in direction: Direction) {
            let newPosition = robot + direction.vector
            switch grid[newPosition] {
            case .empty:
                grid[newPosition] = .robot
                grid[robot] = .empty
                robot = newPosition
            case .box:
                if pushBox(at: robot, in: direction) {
                    grid[newPosition] = .robot
                    grid[robot] = .empty
                    robot = newPosition
                }
            case .wall:
                return
            case .robot:
                return
            case .none:
                return
            }
        }

        mutating func pushBox(at position: Point, in direction: Direction) -> Bool {
            let newPosition = position + direction.vector
            switch grid[newPosition] {
            case .empty:
                grid[newPosition] = .box
                grid[position] = .empty
                return true
            case .wall:
                return false
            case .box:
                guard pushBox(at: newPosition, in: direction) else { return false }
                grid[newPosition] = .box
                grid[position] = .empty
                return true
            case .robot:
                return false
            case .none:
                return false
            }
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var warehouse: Warehouse
    var commands: [Direction]

    init(data: String) {
        let split = data.split(separator: "\n\n")
        let rawGrid = split[0]
            .split(separator: "\n")
            .map {
                $0.map { WarehouseCell(rawValue: $0)! }
            }
        let grid = Grid(grid: rawGrid)
        self.data = data
        self.warehouse = Warehouse(grid: grid, robot: grid.firstIndex(where: { $0 == .robot })!)
        self.commands = split[1].compactMap { Direction(rawValue: $0) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var warehouse = self.warehouse
        let visualizer = { (cell: WarehouseCell) -> String in
            return String(cell.rawValue)
        }
        // print(warehouse.grid.visualize(with: visualizer))
        for direction in commands {
            // print("Moving in \(direction)")
            warehouse.move(in: direction)
            // print(warehouse.grid.visualize(with: visualizer))
        }
        return warehouse.grid.reduce(initial: 0) {
            guard case .box = $1 else { return $0 }
            return $0 + $2.y * 100 + $2.x
        }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
