import Algorithms
import Collections

enum MazeCell: Character {
    case wall = "#"
    case empty = "."
    case start = "S"
    case end = "E"
}

struct Day16: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var maze: Grid<MazeCell>
    var start: Point = .zero
    var end: Point = .zero

    init(data: String) {
        self.data = data
        let rawMaze = data.split(separator: "\n")
            .map { $0.map { MazeCell(rawValue: $0)! } }
        self.maze = Grid(grid: rawMaze)
        self.start = maze.firstIndex(where: { $0 == .start })!
        self.end = maze.firstIndex(where: { $0 == .end })!
        self.maze[start] = .empty
        self.maze[end] = .empty
    }

    struct Step: Hashable {
        var position: Point
        var direction: Direction
    }
    struct ValuedStep: Hashable, Comparable {
        var step: Step
        var position: Point { step.position }
        var direction: Direction { step.direction }
        var value: Int

        static func < (lhs: ValuedStep, rhs: ValuedStep) -> Bool {
            lhs.value < rhs.value
        }
        func stepForward() -> ValuedStep {
            ValuedStep(
                step: Step(position: position + direction.vector, direction: direction),
                value: value + 1
            )
        }
        func barrelRoll() -> ValuedStep {
            ValuedStep(
                step: Step(position: position, direction: direction.turnRight().turnRight()),
                value: value
            )
        }
        func turnRight() -> ValuedStep {
            ValuedStep(
                step: Step(position: position, direction: direction.turnRight()),
                value: value + 1000
            )
        }
        func turnLeft() -> ValuedStep {
            ValuedStep(
                step: Step(position: position, direction: direction.turnLeft()),
                value: value + 1000
            )
        }
    }

    func evaluateGrid() -> [Step: Int] {
        var heap = Heap<ValuedStep>()
        let startStep = Step(position: start, direction: .east)
        var visited: [Step: Int] = [startStep: 0]
        heap.insert(ValuedStep(step: startStep, value: 0))

        @discardableResult
        func tryStep(_ step: ValuedStep) -> Bool {
            if let visitedValue = visited[step.step], visitedValue <= step.value {
                // we already visited this step with a shorter path
                return false
            }
            visited[step.step] = step.value
            heap.insert(step)
            return true
        }
        var bestValue = Int.max
        while !heap.isEmpty {
            let current = heap.removeMin()
            if current.value > bestValue { continue }

            let stepForward = current.stepForward()
            if stepForward.position == end {
                bestValue = min(bestValue, stepForward.value)
                continue
            }
            if maze[stepForward.position] != .wall {
                if tryStep(stepForward) {
                    visited[stepForward.barrelRoll().step] = stepForward.value  // why would you go back?
                }
            }
            tryStep(current.turnRight())
            tryStep(current.turnLeft())
        }
        visited[Step(position: end, direction: .east)] = bestValue
        visited[Step(position: end, direction: .west)] = bestValue
        visited[Step(position: end, direction: .north)] = bestValue
        visited[Step(position: end, direction: .south)] = bestValue
        return visited
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let visited = evaluateGrid()
        return visited[Step(position: end, direction: .east)]!
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let visited = evaluateGrid()
        var sits = Set([end])

        var queue = Deque<Step>([
            Step(position: end, direction: .east)
        ])
        while !queue.isEmpty {
            let current = queue.removeFirst()
            sits.insert(current.position)
            if current.position == start { continue }
            let value = visited[current]!
            let neighbors = Direction.allCases
                .map { Step(position: current.position + $0.vector, direction: $0) }
                .filter { maze[$0.position] != .wall }
                .filter {
                    guard let visitedValue = visited[$0] else { return false }
                    return visitedValue == value - 1 || visitedValue == value - 1001
                }
            queue.append(contentsOf: neighbors)
        }
        return sits.count
    }
}
