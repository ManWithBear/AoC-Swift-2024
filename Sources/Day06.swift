import Algorithms

/// A direction from which the guard came.
struct Visited: OptionSet {
    let rawValue: Int
    static let fromSouth = Visited(rawValue: 1 << 0)
    static let fromWest = Visited(rawValue: 1 << 1)
    static let fromNorth = Visited(rawValue: 1 << 2)
    static let fromEast = Visited(rawValue: 1 << 3)
}

enum Cell: Equatable {
    case wall
    case visited(Visited)

    init?(rawValue: Character) {
        switch rawValue {
        case ".": self = .visited([])
        case "#": self = .wall
        default: return nil
        }
    }

    var isVisited: Bool {
        guard case let .visited(visited) = self else { return false }
        return visited != []
    }

    mutating func came(from direction: Direction) {
        guard case let .visited(visited) = self else { return }
        self = .visited(visited.union(direction.toVisited))
    }
}
extension Direction {
    var toVisited: Visited {
        switch self {
        case .north: return .fromSouth
        case .east: return .fromWest
        case .south: return .fromNorth
        case .west: return .fromEast
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

struct SimulationState {
    var grid: [[Cell]]
    var guardsDirection: Direction
    var guardsPosition: (y: Int, x: Int)
    var height: Int { grid.count }
    var width: Int { grid[0].count }

    func canStep(to position: (y: Int, x: Int)) -> Bool {
        !(grid[position.y][position.x] ~= .wall)
    }

    func isOutOfBounds(_ position: (y: Int, x: Int)) -> Bool {
        position.y < 0 || position.y >= height || position.x < 0 || position.x >= width
    }

    func hasCame(to position: (y: Int, x: Int), movingIn direction: Direction) -> Bool {
        guard case let .visited(visited) = grid[position.y][position.x] else { return false }
        return visited.contains(direction.toVisited)
    }

    mutating func step(to position: (y: Int, x: Int)) {
        grid[position.y][position.x].came(from: guardsDirection)
        guardsPosition = position
    }
}

struct Simulation {
    var state: SimulationState
    var isFinished: Bool
    var isLooped: Bool

    init(state: SimulationState) {
        self.state = state
        let isOutOfBounds = state.isOutOfBounds(state.guardsPosition)
        let pianoDropped = state.grid[state.guardsPosition.y][state.guardsPosition.x] == .wall
        self.isFinished = isOutOfBounds || pianoDropped
        self.isLooped = false
    }

    mutating func step() {
        guard !isFinished else { return }

        let nextPosition = state.guardsDirection.step(from: state.guardsPosition)
        if state.isOutOfBounds(nextPosition) {
            isFinished = true
            return
        }
        if state.canStep(to: nextPosition) {
            if state.hasCame(to: nextPosition, movingIn: state.guardsDirection) {
                isLooped = true
                isFinished = true
                return
            } else {
                state.step(to: nextPosition)
            }
        } else {
            state.guardsDirection = state.guardsDirection.turnRight()
        }
    }

    mutating func run() {
        while !isFinished {
            step()
        }
    }
}

final class Day06: @unchecked Sendable, AdventDay {
    var data: String
    var startingState: SimulationState

    init(data: String) {
        self.data = data
        var direction = Direction.north
        let grid = data.split(separator: "\n").map {
            $0.map {
                guard let cell = Cell(rawValue: $0) else {
                    direction = Direction(rawValue: $0)!
                    return Cell.visited(direction.toVisited)
                }
                return cell
            }
        }
        let guardPosition: (y: Int, x: Int) = {
            for y in 0..<grid.count {
                for x in 0..<grid[y].count {
                    if grid[y][x].isVisited {
                        return (y, x)
                    }
                }
            }
            fatalError("No guard position found")
        }()
        self.startingState = SimulationState(
            grid: grid,
            guardsDirection: direction,
            guardsPosition: guardPosition
        )
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var simulation = Simulation(state: startingState)
        simulation.run()
        return simulation.state.grid
            .map { $0.count { $0.isVisited } }
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let normalPath = {
            var simulation = Simulation(state: startingState)
            simulation.run()
            return simulation.state.grid
                .enumerated()
                .flatMap { y, row in
                    row.enumerated().compactMap { x, cell in
                        if cell.isVisited {
                            return (y: y, x: x)
                        }
                        return nil
                    }
                }
        }()
        return normalPath.count { toBlock in
            var grid = startingState.grid
            grid[toBlock.y][toBlock.x] = .wall
            var simulation = Simulation(
                state: SimulationState(
                    grid: grid,
                    guardsDirection: startingState.guardsDirection,
                    guardsPosition: startingState.guardsPosition
                )
            )
            simulation.run()
            // print("Blocking [\(toBlock.x), \(toBlock.y)] -> \(simulation.isLooped ? "🔄" : "❌")")
            return simulation.isLooped
        }
    }
}
