/*
Exercise: Stringers
Make the IPAddr type implement fmt.Stringer to print the address as a dotted quad.

For instance, IPAddr{1, 2, 3, 4} should print as "1.2.3.4".
*/

package main

import (
	"fmt"
	"strconv"
	"strings"
)

type iPAddr [4]byte

func (ip iPAddr) String() string {
	arr := []string{"0", ".", "0", ".", "0", ".", "0"}
	for i := 0; i < 4; i++ {
		arr[i<<1] = strconv.Itoa(int(ip[i]))
	}
	sip := strings.Join(arr, "")
	return sip
}

func main() {
	hosts := map[string]iPAddr{
		"loopback":  {127, 0, 0, 1},
		"googleDNS": {8, 8, 8, 8},
	}
	for name, ip := range hosts {
		fmt.Printf("%v: %v\n", name, ip)
	}
}
