import java.io.File
import kotlin.math.abs

object Day12 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day12Input.txt")
        .readLines()

    fun parseInput() = inputLines.map { it.first() to it.drop(1).toInt() }

    fun part1() {
        val boat = Boat()

        parseInput().forEach {
            boat.makeMovePart1(it)
        }

        println(abs(boat.x) + abs(boat.y))
    }

    fun part2() {
        val boat = Boat()
        val waypoint = Waypoint()

        parseInput().forEach {
            boat.showPosition()
            if (it.first == 'F')  boat.moveToWaypoint(waypoint,it.second) else waypoint.makeMove(it,boat)
        }

        println(abs(boat.x) + abs(boat.y))
    }
}




class Waypoint : Vessel() {

    init {
        x = 10
        y = 1
    }

    fun makeMove(command : Pair<Char, Int>, boat : Boat) {
        if (command.first.isATurn()) {
            turnAround(boat,command)
        } else {
            move(command.first,command.second)
        }
    }

    private fun turnAround(boat : Boat, command: Pair<Char, Int>) {
        if (command.first == 'R') turnRightAround(boat,command.second) else turnLeftAround(boat,command.second)
    }

    private fun turnRightAround(boat : Boat, size : Int) {
        val point = boat.vectorTo(this)
        when (size) {
            90 -> {
                x = boat.x + point.second
                y = boat.y - point.first
            }
            180 -> fullTurn(boat,point)
            270 -> turnLeftAround(boat,90)
        }

    }

    private fun turnLeftAround(boat : Boat, size : Int) {
        val point = boat.vectorTo(this)
        when (size) {
            90 ->  {
                x = boat.x - point.second
                y = boat.y + point.first
            }
            180 -> fullTurn(boat,point)
            270 -> turnRightAround(boat,90)
        }
    }

    private fun fullTurn(boat : Boat, vector : Pair<Int, Int>) {
        this.x = boat.x - vector.first
        this.y = boat.y - vector.second
    }
}

class Boat : Vessel() {
    var facing = CompassDirections.EAST

    fun makeMovePart1(command : Pair<Char, Int>) {
        if (command.first.isATurn()) {
            changeDirection(command)
        } else {
            movePart1(command)
        }
    }

    fun moveToWaypoint(waypoint: Waypoint, size : Int) {
        val moveToMake = this.vectorTo(waypoint)

        x += moveToMake.first*size
        y += moveToMake.second*size

        waypoint.x = this.x + moveToMake.first
        waypoint.y = this.y + moveToMake.second
    }

    private fun changeDirection(command : Pair<Char, Int>) {
        facing = if (command.first == 'R') {
            facing.turnByDegreesRight(command.second)
        } else {
            facing.turnByDegreesLeft(command.second)
        }
    }

    private fun movePart1(command : Pair<Char, Int>) {
        val direction = if (command.first == 'F') facing.letter() else command.first
        val size = command.second

        move(direction,size)
    }
}

open class Vessel {
    var x = 0
    var y = 0

    fun move(direction : Char, size : Int) {
        when (direction) {
            'N' -> y += size
            'S' -> y -= size
            'E' -> x += size
            'W' -> x -= size
        }
    }

    fun vectorTo(other : Vessel) : Pair<Int,Int> {
        return (other.x - this.x) to (other.y - this.y)
    }


    fun showPosition() {
        println("$x,$y")
    }
}

enum class CompassDirections {
    NORTH,SOUTH,EAST,WEST;

    private fun turnLeft(): CompassDirections {
        return when(this) {
            NORTH -> WEST
            SOUTH -> EAST
            EAST -> NORTH
            WEST -> SOUTH
        }
    }

    private fun turnRight(): CompassDirections {
        return when(this) {
            NORTH -> EAST
            SOUTH -> WEST
            EAST -> SOUTH
            WEST -> NORTH
        }
    }

    fun turnByDegreesRight(n : Int) : CompassDirections {
        return when(n) {
            90 -> turnRight()
            180 -> turnRight().turnRight()
            270 -> turnRight().turnByDegreesRight(180)
            else -> this
        }
    }

    fun turnByDegreesLeft(n : Int) : CompassDirections {
        return when(n) {
            90 -> turnLeft()
            180 -> turnLeft().turnLeft()
            270 -> turnLeft().turnByDegreesLeft(180)
            else -> this
        }
    }

    fun letter() : Char {
        return when(this) {
            NORTH -> 'N'
            SOUTH -> 'S'
            EAST -> 'E'
            WEST -> 'W'
        }
    }
}


fun Char.isATurn() = this == 'R' || this == 'L'