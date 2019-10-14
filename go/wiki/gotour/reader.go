/*
Exercise: Readers
Implement a Reader type that emits an infinite stream of the ASCII character 'A'.
*/

package main

import "golang.org/x/tour/reader"

type myReader struct{}

func (r myReader) Read(c []byte) (int, error) {
	i := 0
	for ; i < len(c); i++ {
		c[i] = 'A'
	}
	for ; i < cap(c); i++ {
		c = append(c, 'A')
	}

	return cap(c), nil
}

func main() {
	reader.Validate(myReader{})
}
