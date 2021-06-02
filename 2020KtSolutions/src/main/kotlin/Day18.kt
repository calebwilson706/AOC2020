import java.io.File

object Day18 {

    private val inputLines =  File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day18Input.txt").readLines()

    fun part1() {
        solution(1)
    }

    fun part2() {
        solution(2)
    }

    private fun solution(part : Int) {
        println(
            inputLines.foldRight(0) { line, acc : Long ->
                acc + line.evaluate(part)
            }
        )
    }

    private fun String.evaluate(part : Int)  = compress(part == 2).evaluateNoPrecedence()

    private fun String.compress(isPrecedence : Boolean) : String {

        val updatedAfterApplyingPrecedence = if (isPrecedence) {
            this.replaceAdditions()
        } else {
            this
        }

        return updatedAfterApplyingPrecedence.findHighestPriorityBracket()?.let { bracketed ->
            val replacement = bracketed.removeEnclosingBrackets().evaluateNoPrecedence().toString()
            updatedAfterApplyingPrecedence.replace(bracketed, replacement).compress(isPrecedence)
        } ?: updatedAfterApplyingPrecedence

    }

    private fun String.removeEnclosingBrackets() = this.drop(1).dropLast(1)

    private fun String.findHighestPriorityBracket() : String? {
        if (!this.contains("(")) {
            return null
        }

        val bracketsDeepAtIndices = mutableMapOf<Int, Int>()
        val closeBracketsIndices = mutableSetOf<Int>()
        var bracketsDeepCurrently = 0

        this.forEachIndexed { index, character ->
            when (character) {
                '(' -> {
                    bracketsDeepAtIndices[index] = bracketsDeepCurrently
                    bracketsDeepCurrently += 1
                }
                ')' -> {
                    closeBracketsIndices.add(index)
                    bracketsDeepCurrently -= 1
                }
            }
        }

        val startIndex = bracketsDeepAtIndices.maxByOrNull { it.value }!!.key
        val endIndex = closeBracketsIndices.filter { it > startIndex }.minByOrNull { it - startIndex }!!

        return this.substring(startIndex .. endIndex)
    }

    private fun String.replaceAdditions() : String {
        val additionRegex = "([0-9]+) \\+ ([0-9]+)".toRegex()

        val result = this.replace(additionRegex) { match ->
            val (x,y) = match.destructured
            "${x.toInt() + y.toInt()}"
        }

        return if (additionRegex.find(result) != null) {
            result.replaceAdditions()
        } else {
            result
        }
    }

    private fun String.evaluateNoPrecedence() : Long {
        val numbers = getNumbers()
        val signs = getSigns()
        var total = numbers.first()

        signs.forEachIndexed { index, character ->
            val nextNumber = numbers[index + 1]

            if (character == '*') {
                total *= nextNumber
            } else {
                total += nextNumber
            }
        }

        return total
    }

    private fun String.getSigns() = this.filter { it == '*' || it == '+' }

    private fun String.getNumbers() = this.split(" [*+] ".toRegex()).map { it.toLong() }

}

