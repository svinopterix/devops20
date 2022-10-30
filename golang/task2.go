package main
import "fmt"


func min_element(s []int) int {

   min := s[0]

   for i := range s {
     if s[i] < min {
        min = s[i]
     }
   }

   return min
}


func main() {

  x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}

  min_x := min_element(x)


  fmt.Println("Minimal element in x is: ", min_x)

}
