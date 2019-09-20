/*
Exercise: rot13Reader
A common pattern is an io.Reader that wraps another io.Reader, modifying the stream in some way.

For example, the gzip.NewReader function takes an io.Reader (a stream of compressed data) and returns a *gzip.Reader that also implements io.Reader (a stream of the decompressed data).

Implement a rot13Reader that implements io.Reader and reads from an io.Reader, modifying the stream by applying the rot13 substitution cipher to all alphabetical characters.

The rot13Reader type is provided for you. Make it an io.Reader by implementing its Read method.
*/

package main

import (
	"io"
	"os"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func rot13(b byte) byte {
	if b >= 'a' && b <= 'm' {
		return b + 13
	}
	if b >= 'n' && b <= 'z' {
		return b - 'n' + 'a'
	}
	if b >= 'A' && b <= 'M' {
		return b + 13
	}
	if b >= 'N' && b <= 'Z' {
		return b - 'N' + 'A'
	}
	return b
}

var rot13Map = make(map[byte]byte)

func initializeRot13Map() {
	s1 := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	s2 := "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
	for i := 0; i < len(s1); i++ {
		rot13Map[s1[i]] = s2[i]
	}
}

func rot13ByMap(b byte) byte {
	val, ok := rot13Map[b]
	if ok {
		return val
	}
	return b
}

func (rot rot13Reader) Read(c []byte) (int, error) {
	b := make([]byte, 8)
	n, err := rot.r.Read(b)
	initializeRot13Map()
	for i := 0; i < n; i++ {
		// b[i] = rot13(b[i])
		b[i] = rot13ByMap(b[i])
	}
	if err == io.EOF {
		return n, err
	}
	copy(c, b)
	return n, nil
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
