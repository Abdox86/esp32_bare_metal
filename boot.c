/**
 * @author: Abdulfatah M. Alturshani
 * @cretid: to vivonomicon blog
 *          https://vivonomicon.com/2019/03/30/getting-started-with-bare-metal-esp32-programming/
 *          
 *          aslo to  Sergey Lyubka
 *          https://github.com/cpq/mdk 
*/



/**
 * This boot.c file is used to define the method _reset() to: 
 * 1- initialize  the .bss section to 0s using memset().
 * 2- copy the values to .data section using memmove().
 * 3- disable the watch dog timer.
 * 4- call main() method.
*/

