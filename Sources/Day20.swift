import Algorithms

struct Day20: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var saveAtLeast: Int
    var maze: Grid<MazeCell>
    var start: Point
    var end: Point

    init(data: String) {
        self.init(data: data, saveAtLeast: 100)
    }

    init(data: String, saveAtLeast: Int) {
        self.data = data
        self.saveAtLeast = saveAtLeast
        let rawMaze = data.split(separator: "\n")
            .map { $0.map { MazeCell(rawValue: $0)! } }
        self.maze = Grid(grid: rawMaze)
        self.start = maze.firstIndex(where: { $0 == .start })!
        self.end = maze.firstIndex(where: { $0 == .end })!
        self.maze[start] = .empty
        self.maze[end] = .empty
    }

    func evaluatePath() -> [Point: Int] {
        var visited: [Point: Int] = [start: 0]
        var queue = Deque<Point>([start])
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let currentTime = visited[current]!
            for neighbor in current.neighbors4 {
                if maze[neighbor] != .wall {
                    if visited[neighbor] == nil {
                        visited[neighbor] = currentTime + 1
                        queue.append(neighbor)
                    }
                }
            }
        }
        return visited
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let visited = evaluatePath()
        var cheats = 0
        for (point, time) in visited {
            for neighbor in point.doubleNeighbors {
                guard let neighborTime = visited[neighbor] else { continue }
                let saved = time - neighborTime - 2
                if saved >= saveAtLeast {
                    cheats += 1
                }
            }
        }
        return cheats
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
