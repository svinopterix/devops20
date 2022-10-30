package main
import "fmt"


func meter2foot(m float64) float64 {
    ft := m / 0.3048

    return ft
}


func main() {
    fmt.Print("Enter length in meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := meter2foot(input)

    fmt.Printf("%v meters is %v foots\n", input, output)    
}
