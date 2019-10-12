/*
Exercise: Images
Remember the picture generator you wrote earlier? Let's write another one, but this time it will return an implementation of image.Image instead of a slice of data.

Define your own Image type, implement the necessary methods, and call pic.ShowImage.

Bounds should return a image.Rectangle, like image.Rect(0, 0, w, h).

ColorModel should return color.RGBAModel.

At should return a color; the value v in the last picture generator corresponds to color.RGBA{v, v, 255, 255} in this one.
*/

package main

import (
	"image"
	"image/color"
	"math"

	"golang.org/x/tour/pic"
)

/*
type Image interface {
	// ColorModel returns the Image's color model.
	ColorModel() color.Model
	// Bounds returns the domain for which At can return non-zero color.
	// The bounds do not necessarily contain the point (0, 0).
	Bounds() Rectangle
	// At returns the color of the pixel at (x, y).
	// At(Bounds().Min.X, Bounds().Min.Y) returns the upper-left pixel of the grid.
	// At(Bounds().Max.X-1, Bounds().Max.Y-1) returns the lower-right one.
	At(x, y int) color.Color
}
*/

type myImage struct{}

func (img myImage) ColorModel() color.Model {
	return color.NRGBAModel
}

func (img myImage) Bounds() image.Rectangle {
	return image.Rect(0, 0, 100, 100)
}

func (img myImage) At(x, y int) color.Color {
	val := float64(x ^ y)
	v := uint8(math.Abs(val))
	return color.RGBA{v, v, 255, 255}
}

func main() {
	m := myImage{}
	pic.ShowImage(m)
}
