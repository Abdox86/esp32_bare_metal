/**
 * @author: Abdulfatah M. Alturshani
 * @cretid: to vivonomicon blog
 *          https://vivonomicon.com/2019/03/30/getting-started-with-bare-metal-esp32-programming/
 *          
 *          aslo to  Sergey Lyubka
 *          https://github.com/cpq/mdk 
*/

/**
 * This ll_register.h file is used to define the low-level registers with 
 * labels instead of address to abstract the complixe use of addresses as 
 * hex numbers.
*/

#pragma once

#include <stdint.h>

#define BIT(x) ((uint32_t) 1U << (x))
#define REG(x) ((volatile uint32_t *) (x))

