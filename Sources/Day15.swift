import Algorithms

struct BasicWarehouse {
    enum Cell: Character, Equatable {
        case wall = "#"
        case empty = "."
        case box = "O"
        case robot = "@"
    }
    var grid: Grid<Cell>
    var robot: Point = .zero

    mutating func move(in direction: Direction) {
        let newPosition = robot + direction.vector
        switch grid[newPosition] {
        case .empty:
            grid[newPosition] = .robot
            grid[robot] = .empty
            robot = newPosition
        case .box:
            if pushBox(at: newPosition, in: direction) {
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

    func gpc() -> Int {
        grid.reduce(initial: 0) {
            guard case .box = $1 else { return $0 }
            return $0 + $2.y * 100 + $2.x
        }
    }
}

struct WideWarehouse {
    enum Cell: Character, Equatable {
        case wall = "#"
        case empty = "."
        case boxLeft = "["
        case boxRight = "]"
        case robot = "@"

        static func fromBasic(_ cell: BasicWarehouse.Cell) -> [Self] {
            switch cell {
            case .wall: return [.wall, .wall]
            case .empty: return [.empty, .empty]
            case .box: return [.boxLeft, .boxRight]
            case .robot: return [.robot, .empty]
            }
        }
    }
    var grid: Grid<Cell>
    var robot: Point = .zero

    mutating func move(in direction: Direction) {
        let newPosition = robot + direction.vector
        switch grid[newPosition] {
        case .empty:
            grid[newPosition] = .robot
            grid[robot] = .empty
            robot = newPosition
        case .boxLeft, .boxRight:
            if pushBox(at: newPosition, in: direction) {
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
        direction.isHorizontal
            ? pushBoxHorizontally(at: position, in: direction)
            : pushBoxVertically(at: position, in: direction)
    }

    mutating func pushBoxHorizontally(at position: Point, in direction: Direction) -> Bool {
        let secondPart = position + direction.vector
        let newPosition = position + direction.vector + direction.vector  // 2 wide
        switch grid[newPosition] {
        case .empty:
            grid[newPosition] = grid[secondPart]
            grid[secondPart] = grid[position]
            grid[position] = .empty
            return true
        case .wall:
            return false
        case .boxLeft, .boxRight:
            guard pushBox(at: newPosition, in: direction) else { return false }
            grid[newPosition] = grid[secondPart]
            grid[secondPart] = grid[position]
            grid[position] = .empty
            return true
        case .robot:
            return false
        case .none:
            return false
        }
    }

    mutating func forcePushBoxVertically(at positionLeft: Point, in direction: Direction) {
        let positionRight = positionLeft + Point(x: 1, y: 0)
        let newPositionLeft = positionLeft + direction.vector
        let newPositionRight = positionRight + direction.vector
        grid[newPositionLeft] = grid[positionLeft]
        grid[newPositionRight] = grid[positionRight]
        grid[positionLeft] = .empty
        grid[positionRight] = .empty
    }

    mutating func pushBoxVertically(at position: Point, in direction: Direction) -> Bool {
        let positionLeft = grid[position] == .boxLeft ? position : (position + Point(x: -1, y: 0))
        guard canPushBoxVertically(at: positionLeft, in: direction) else { return false }
        _pushBoxVertically(at: positionLeft, in: direction)
        return true
    }

    func canPushBoxVertically(at positionLeft: Point, in direction: Direction) -> Bool {
        let positionRight = positionLeft + Point(x: 1, y: 0)
        let newPositionLeft = positionLeft + direction.vector
        let newPositionRight = positionRight + direction.vector
        switch (grid[newPositionLeft], grid[newPositionRight]) {
        case (.empty, .empty):
            return true
        case (.wall, _), (_, .wall):
            return false
        case (.robot, _), (_, .robot):
            fatalError("Trying to push box into robot")
        case (.boxLeft, .boxRight):
            return canPushBoxVertically(at: newPositionLeft, in: direction)
        case (.boxRight, .boxLeft):
            return canPushBoxVertically(at: newPositionRight, in: direction)
                && canPushBoxVertically(at: newPositionLeft + Point(x: -1, y: 0), in: direction)
        case (.boxRight, .empty):
            return canPushBoxVertically(at: newPositionLeft + Point(x: -1, y: 0), in: direction)
        case (.empty, .boxLeft):
            return canPushBoxVertically(at: newPositionRight, in: direction)
        default:
            return false
        }
    }

    // Assumes you can push box vertically
    mutating func _pushBoxVertically(at positionLeft: Point, in direction: Direction) {
        let positionRight = positionLeft + Point(x: 1, y: 0)
        let newPositionLeft = positionLeft + direction.vector
        let newPositionRight = positionRight + direction.vector
        switch (grid[newPositionLeft], grid[newPositionRight]) {
        case (.wall, _), (_, .wall):
            fatalError("Wall in the way")
        case (.robot, _), (_, .robot):
            fatalError("Trying to push box into robot")
        case (.empty, .empty):
            forcePushBoxVertically(at: positionLeft, in: direction)
        case (.boxLeft, .boxRight):
            _pushBoxVertically(at: newPositionLeft, in: direction)
            forcePushBoxVertically(at: positionLeft, in: direction)
        case (.boxRight, .boxLeft):
            _pushBoxVertically(at: newPositionLeft + Point(x: -1, y: 0), in: direction)
            _pushBoxVertically(at: newPositionRight, in: direction)
            forcePushBoxVertically(at: positionLeft, in: direction)
        case (.boxRight, .empty):
            _pushBoxVertically(at: newPositionLeft + Point(x: -1, y: 0), in: direction)
            forcePushBoxVertically(at: positionLeft, in: direction)
        case (.empty, .boxLeft):
            _pushBoxVertically(at: newPositionRight, in: direction)
            forcePushBoxVertically(at: positionLeft, in: direction)
        default:
            fatalError("Someone broke a box?")
        }
    }

    func gpc() -> Int {
        return grid.reduce(initial: 0) {
            guard case .boxLeft = $1 else { return $0 }
            return $0 + $2.y * 100 + $2.x
        }
    }
}

struct Day15: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var warehouse: BasicWarehouse
    var wideWarehouse: WideWarehouse
    var commands: [Direction]

    init(data: String) {
        let split = data.split(separator: "\n\n")
        let rawGrid = split[0]
            .split(separator: "\n")
            .map {
                $0.map { BasicWarehouse.Cell(rawValue: $0)! }
            }
        let grid = Grid(grid: rawGrid)
        self.data = data
        self.warehouse = BasicWarehouse(
            grid: grid,
            robot: grid.firstIndex(where: { $0 == .robot })!
        )
        let rawWideGrid = rawGrid.map {
            $0.flatMap { WideWarehouse.Cell.fromBasic($0) }
        }
        let wideGrid = Grid(grid: rawWideGrid)
        self.wideWarehouse = WideWarehouse(
            grid: wideGrid,
            robot: wideGrid.firstIndex(where: { $0 == .robot })!
        )
        self.commands = split[1].compactMap { Direction(rawValue: $0) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var warehouse = self.warehouse
        for direction in commands {
            warehouse.move(in: direction)
        }
        return warehouse.gpc()
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        var warehouse = self.wideWarehouse
        for direction in commands {
            warehouse.move(in: direction)
        }
        return warehouse.gpc()
    }
}
