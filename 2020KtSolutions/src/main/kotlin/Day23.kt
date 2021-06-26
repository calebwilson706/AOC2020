

// use a map as a linked list storing the first cup and then each cup should point to the next one


object Day23 {
    private val puzzleInput = listOf(5, 8, 6, 4, 3, 9, 1, 7, 2)
    private const val million = 1000000

    fun part1() {
        val cups = mutableMapOf<Int, Int>()

        puzzleInput.dropLast(1).forEachIndexed { index, number ->
            cups[number] = puzzleInput[index + 1]
        }

        cups[puzzleInput.last()] = puzzleInput.first()

        val min = puzzleInput.minOrNull()!!
        val max = puzzleInput.maxOrNull()!!

        val finalResult = getEndCupFormation(cups, puzzleInput.first(), min, max, 100)

        var currentCup = finalResult[1]!!

        while (currentCup != 1) {
            print(currentCup)
            currentCup = finalResult[currentCup]!!
        }

    }

    fun part2() {
        val cups = mutableMapOf<Int, Int>()

        puzzleInput.dropLast(1).forEachIndexed { index, number ->
            cups[number] = puzzleInput[index + 1]
        }

        val lowestUnused = puzzleInput.maxOrNull()!! + 1

        cups[puzzleInput.last()] = lowestUnused

        (lowestUnused until million).forEach {
            cups[it] = it + 1
        }

        cups[million] = puzzleInput.first()

        val finalResult = getEndCupFormation(cups, puzzleInput.first(), puzzleInput.minOrNull()!!, million, million*10)

        val afterOne = finalResult[1]!!

        println(afterOne.toLong()*finalResult[afterOne]!!.toLong())
    }

    private fun getEndCupFormation(cups : MutableMap<Int, Int>, firstCup : Int, min : Int, max : Int, count : Int): MutableMap<Int, Int> {
        var start = firstCup

        (0 until count).forEach { _ ->
            start = cups.makeMoveAndGetNextStartingPoint(start,min,max)
        }

        return cups
    }

    private fun MutableMap<Int, Int>.makeMoveAndGetNextStartingPoint(startingPoint: Int, min : Int, max : Int) : Int {
        val threeCupsRemoved = this.getNextThreeItems(startingPoint)
        this[startingPoint] = this[threeCupsRemoved.last()]!!

        val target = findTarget(startingPoint - 1, threeCupsRemoved.toSet(), min, max)

        val previousTargetNext = this[target]!!
        this[target] = threeCupsRemoved.first()
        this[threeCupsRemoved.last()] = previousTargetNext

        return this[startingPoint]!!
    }

    private fun MutableMap<Int, Int>.getNextThreeItems(startingPoint: Int) : List<Int> {
        var currentNumber = startingPoint
        val result = mutableListOf<Int>()

        (1 .. 3).forEach { _ ->
            currentNumber = this[currentNumber]!!
            result.add(currentNumber)
        }

        return result
    }

    private fun findTarget(startingTarget : Int, removedSet : Set<Int>, min : Int, max: Int) : Int {
        var target = startingTarget

        if (target < min) {
            target = max
        }

        while (removedSet.contains(target)) {
            target -= 1
            if (target < min) {
                target = max
            }
        }

        return target
    }
}