/*
Exercise: Maps
Implement WordCount. It should return a map of the counts of each “word” in the string s. The wc.Test function runs a test suite against the provided function and prints success or failure.

You might find strings.Fields helpful.
*/

package main

import (
	"strings"

	"golang.org/x/tour/wc"
)

func wordCount(s string) map[string]int {
	m := make(map[string]int)
	var ss []string
	ss = strings.Fields(s)
	for i := 0; i < len(ss); i++ {
		m[ss[i]]++
	}

	return m
}

func main() {
	wc.Test(wordCount)
}
