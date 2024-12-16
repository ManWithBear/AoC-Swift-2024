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

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
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
        }
        var heap = Heap<ValuedStep>()
        let startStep = Step(position: start, direction: .east)
        var visited: [Step: Int] = [startStep: 0]
        heap.insert(ValuedStep(step: startStep, value: 0))

        @discardableResult
        func tryStep(_ step: ValuedStep) -> Bool {
            if let visitedValue = visited[step.step], visitedValue >= step.value {
                // we already visited this step with a shorter path
                return false
            }
            visited[step.step] = step.value
            heap.insert(step)
            return true
        }
        while !heap.isEmpty {
            let current = heap.removeMin()

            let stepForward = ValuedStep(
                step: Step(
                    position: current.position + current.direction.vector,
                    direction: current.direction
                ),
                value: current.value + 1
            )
            if stepForward.position == end {
                return stepForward.value
            }
            if maze[stepForward.position] != .wall {
                if tryStep(stepForward) {
                    let step180 = Step(
                        position: stepForward.position,
                        direction: stepForward.direction.turnLeft().turnLeft()
                    )
                    visited[step180] = stepForward.value  // why would you go back?
                }
            }

            let turnRight = ValuedStep(
                step: Step(
                    position: current.position,
                    direction: current.direction.turnRight()
                ),
                value: current.value + 1000
            )
            tryStep(turnRight)

            let turnLeft = ValuedStep(
                step: Step(
                    position: current.position,
                    direction: current.direction.turnLeft()
                ),
                value: current.value + 1000
            )
            tryStep(turnLeft)
        }
        return -1
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
