package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func simulate_day(fish *[]int) {
	to_append := 0
	for i := 0; i < len(*fish); i++ {
		(*fish)[i]--
		if (*fish)[i] == -1 {
			(*fish)[i] = 6
			to_append++
		}
	}
	for i := 0; i < to_append; i++ {
		*fish = append(*fish, 8)
	}
}

func simulate_day_smart(fish *[9]int) {
	tmp := (*fish)[0]
	for i := 0; i < 8; i++ {
		(*fish)[i] = (*fish)[i+1]
	}
	(*fish)[6] += tmp
	(*fish)[8] = tmp
}

func sum(fish [9]int) int {
	sum := 0
	for i := 0; i < 9; i++ {
		sum += fish[i]
	}
	return sum
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	words := strings.Split(scanner.Text(), ",")
	numbers := [9]int{0, 0, 0, 0, 0, 0, 0, 0, 0}
	for i := 0; i < len(words); i++ {
		res, _ := strconv.ParseInt(words[i], 0, 32)
		numbers[res]++
	}
	for i := 0; i < 80; i++ {
		simulate_day_smart(&numbers)
	}
	fmt.Println("Part 1: ", sum(numbers))
	for i := 0; i < (256 - 80); i++ {
		simulate_day_smart(&numbers)
	}
	fmt.Println("Part 2: ", sum(numbers))
}
