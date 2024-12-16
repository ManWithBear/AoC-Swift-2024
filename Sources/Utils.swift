enum Direction {
    case north
    case east
    case south
    case west

    init?(rawValue: Character) {
        switch rawValue {
        case "^": self = .north
        case ">": self = .east
        case "v": self = .south
        case "<": self = .west
        default: return nil
        }
    }

    var vector: Point {
        switch self {
        case .north: return Point(x: 0, y: -1)
        case .east: return Point(x: 1, y: 0)
        case .south: return Point(x: 0, y: 1)
        case .west: return Point(x: -1, y: 0)
        }
    }

    var isHorizontal: Bool {
        self == .east || self == .west
    }

    func turnRight() -> Self {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }

    func turnLeft() -> Self {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int

    static let zero = Point(x: 0, y: 0)

    static func + (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

struct Grid<T: Sendable> {
    var grid: [[T]]
    var width: Int
    var height: Int

    init(grid: [[T]]) {
        self.grid = grid
        self.width = grid[0].count
        self.height = grid.count
    }

    func isInBounds(point: Point) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }

    subscript(point: Point) -> T? {
        get {
            guard isInBounds(point: point) else { return nil }
            return grid[point.y][point.x]
        }
        set {
            guard isInBounds(point: point) else { return }
            guard let newValue else { return }
            grid[point.y][point.x] = newValue
        }
    }

    func firstIndex(where predicate: (T) -> Bool) -> Point? {
        for y in 0..<height {
            for x in 0..<width {
                if predicate(grid[y][x]) {
                    return Point(x: x, y: y)
                }
            }
        }
        return nil
    }

    func reduce<R>(initial: R, _ reducer: (R, T, Point) -> R) -> R {
        var result = initial
        for y in 0..<height {
            for x in 0..<width {
                result = reducer(result, grid[y][x], Point(x: x, y: y))
            }
        }
        return result
    }

    func visualize(with transform: (T) -> String) -> String {
        grid.map { $0.map { transform($0) }.joined() }.joined(separator: "\n")
    }
}

func numberOfDigits(in number: Int) -> Int {
    String(number).count
}
