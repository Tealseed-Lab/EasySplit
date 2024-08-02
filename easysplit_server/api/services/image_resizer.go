package services

import (
	"bytes"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"io"

	"github.com/nfnt/resize"
)

type ImageResizer struct{}

func NewImageResizer() *ImageResizer {
	return &ImageResizer{}
}

func (ir *ImageResizer) ResizeImage(img image.Image, size uint) image.Image {
	imgSize := img.Bounds().Max
	if imgSize.X > imgSize.Y {
		return resize.Resize(0, size, img, resize.Lanczos3)
	} else {
		return resize.Resize(size, 0, img, resize.Lanczos3)
	}
}

func (ir *ImageResizer) DecodeAndResizeImage(imageBytes []byte, size uint) ([]byte, string, error) {
	reader := bytes.NewReader(imageBytes)
	img, format, err := image.Decode(reader)
	if err != nil {
		reader.Seek(0, io.SeekStart)
		img, err = jpeg.Decode(reader)
		if err == nil {
			format = "jpeg"
		} else {
			reader.Seek(0, io.SeekStart)
			img, err = png.Decode(reader)
			format = "png"
			if err != nil {
				return nil, "", err
			}
		}
	}

	resizedImg := ir.ResizeImage(img, size)

	var buf bytes.Buffer
	switch format {
	case "jpeg":
		err = jpeg.Encode(&buf, resizedImg, nil)
	case "png":
		err = png.Encode(&buf, resizedImg)
	default:
		return nil, "", fmt.Errorf("unsupported image format: %s", format)
	}

	if err != nil {
		return nil, "", err
	}

	return buf.Bytes(), format, nil
}
