/*
Exercise: Errors
Copy your Sqrt function from the earlier exercise and modify it to return an error value.

Sqrt should return a non-nil error value when given a negative number, as it doesn't support complex numbers.

Create a new type

type ErrNegativeSqrt float64
and make it an error by giving it a

func (e ErrNegativeSqrt) Error() string
method such that ErrNegativeSqrt(-2).Error() returns "cannot Sqrt negative number: -2".

Note: A call to fmt.Sprint(e) inside the Error method will send the program into an infinite loop. You can avoid this by converting e first: fmt.Sprint(float64(e)). Why?

Change your Sqrt function to return an ErrNegativeSqrt value when given a negative number.
*/

package main

import (
	"fmt"
	"math"
)

type errNegativeSqrt float64

func (e errNegativeSqrt) Error() string {
	// 因为e变量是一个通过实现Error()的接口函数成为了error类型，那么在fmt.Sprint(e)时就会调用e.Error()来输出错误的字符串信息
	return fmt.Sprint("cannot Sqrt negative number: ", float64(e))
}

func mySqrt(x float64) (float64, error) {
	if x < 0 {
		return -1, errNegativeSqrt(x)
	}
	z := x / 2
	tmp := 0.0
	for math.Abs(z-tmp) >= 0.000000000001 {
		tmp = z
		z -= (z*z - x) / (2 * z)
	}
	return z, nil
}

func main() {
	fmt.Println(mySqrt(2))
	fmt.Println(mySqrt(-2))
}
