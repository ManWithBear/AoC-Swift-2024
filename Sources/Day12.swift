import Algorithms

enum Side {
    case top
    case bottom
    case left
    case right
}

struct Edge {
    var from: Point
    var to: Point
    var side: Side
}

struct Day12: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var grid: [[Character]]
    var width: Int
    var height: Int

    init(data: String) {
        self.data = data
        let grid = data.split(separator: "\n").map { Array($0) }
        self.grid = grid
        self.width = grid[0].count
        self.height = grid.count
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

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        typealias PlotIndex = Int
        var theNextIndex = 0
        var area: [PlotIndex: Int] = [:]
        var perimeter: [PlotIndex: Int] = [:]
        var toVisit: Set<Point> = {
            let points = grid.indices.flatMap { y in
                grid[y].indices.map { x in
                    Point(x: x, y: y)
                }
            }
            return Set(points)
        }()
        while !toVisit.isEmpty {
            let startingPoint = toVisit.removeFirst()
            let char = grid[startingPoint.y][startingPoint.x]
            let index = theNextIndex
            theNextIndex += 1
            area[index] = 0
            perimeter[index] = 0
            var queue: [Point] = [startingPoint]
            while !queue.isEmpty {
                let point = queue.removeFirst()
                area[index]! += 1
                func checkNeighbour(_ point: Point?) {
                    guard let point else {
                        // we need boundsary when on the edge
                        perimeter[index]! += 1
                        return
                    }
                    if grid[point.y][point.x] == char {
                        guard toVisit.contains(point) else { return }
                        // the same plot
                        toVisit.remove(point)
                        queue.append(point)
                    } else {
                        // different plot
                        perimeter[index]! += 1
                    }
                }
                checkNeighbour(getTopNeighbour(for: point))
                checkNeighbour(getBottomNeighbour(for: point))
                checkNeighbour(getLeftNeighbour(for: point))
                checkNeighbour(getRightNeighbour(for: point))
            }
        }
        return (0..<theNextIndex).map { index in
            area[index]! * perimeter[index]!
        }.reduce(0, +)
    }

    func joinEdges(edges: [Edge]) -> [Edge] {
        var top: [Int: [Edge]] = [:]
        var bottom: [Int: [Edge]] = [:]
        var left: [Int: [Edge]] = [:]
        var right: [Int: [Edge]] = [:]
        for edge in edges {
            switch edge.side {
            case .top: top[edge.from.y, default: []].append(edge)
            case .bottom: bottom[edge.from.y, default: []].append(edge)
            case .left: left[edge.from.x, default: []].append(edge)
            case .right: right[edge.from.x, default: []].append(edge)
            }
        }
        func join(edges: [Edge], path: KeyPath<Point, Int>) -> [Edge] {
            return
                edges
                .sorted { $0.from[keyPath: path] < $1.from[keyPath: path] }
                .reduce(into: [Edge]()) { acc, edge in
                    guard let last = acc.last else {
                        acc.append(edge)
                        return
                    }
                    if last.to[keyPath: path] + 1 == edge.from[keyPath: path] {
                        acc.removeLast()
                        acc.append(Edge(from: last.from, to: edge.to, side: edge.side))
                    } else {
                        acc.append(edge)
                    }
                }
        }
        let joinedTops = top.mapValues { join(edges: $0, path: \.x) }
            .values
            .flatMap { $0 }
        let joinedBottoms = bottom.mapValues { join(edges: $0, path: \.x) }
            .values
            .flatMap { $0 }
        let joinedLefts = left.mapValues { join(edges: $0, path: \.y) }
            .values
            .flatMap { $0 }
        let joinedRights = right.mapValues { join(edges: $0, path: \.y) }
            .values
            .flatMap { $0 }
        return joinedTops + joinedBottoms + joinedLefts + joinedRights
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        typealias PlotIndex = Int
        var theNextIndex = 0
        var area: [PlotIndex: Int] = [:]
        var edges: [PlotIndex: [Edge]] = [:]
        var toVisit: Set<Point> = {
            let points = grid.indices.flatMap { y in
                grid[y].indices.map { x in
                    Point(x: x, y: y)
                }
            }
            return Set(points)
        }()
        while !toVisit.isEmpty {
            let startingPoint = toVisit.removeFirst()
            let char = grid[startingPoint.y][startingPoint.x]
            let index = theNextIndex
            theNextIndex += 1
            area[index] = 0
            edges[index] = []
            var queue: [Point] = [startingPoint]
            while !queue.isEmpty {
                let point = queue.removeFirst()
                area[index]! += 1
                func checkNeighbour(_ neighbour: Point?, _ side: Side) {
                    let edge = Edge(from: point, to: point, side: side)
                    guard let neighbour else {
                        // we need boundsary when on the edge
                        edges[index]!.append(edge)
                        return
                    }
                    if grid[neighbour.y][neighbour.x] == char {
                        guard toVisit.contains(neighbour) else { return }
                        // the same plot
                        toVisit.remove(neighbour)
                        queue.append(neighbour)
                    } else {
                        // different plot
                        edges[index]!.append(edge)
                    }
                }
                checkNeighbour(getTopNeighbour(for: point), .top)
                checkNeighbour(getBottomNeighbour(for: point), .bottom)
                checkNeighbour(getLeftNeighbour(for: point), .left)
                checkNeighbour(getRightNeighbour(for: point), .right)
            }
        }
        for index in 0..<theNextIndex {
            edges[index] = joinEdges(edges: edges[index]!)
        }
        return (0..<theNextIndex).map { index in
            area[index]! * edges[index]!.count
        }.reduce(0, +)
    }
}
