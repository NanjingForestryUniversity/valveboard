#ifndef __GPIO_H
#define __GPIO_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h> 

#define GPIO_EXPORT_PATH "/sys/class/gpio/export"
#define GPIO_GET_PIN_STR(pin) #pin
#define GPIO_GET_VALUE_FILE(pin) "/sys/class/gpio/gpio" #pin "/value"
#define GPIO_PINDEF_TO_INDEX(pin_t) ((int)pin_t)
#define GPIO_VALUEDEF_TO_INDEX(value_t) ((int)value_t)

#define ON_ERROR(res, message1, message2)                                                                 \
    if (res < 0)                                                                                          \
    {                                                                                                     \
        sprintf(perror_buffer, "error %d at %s:%d, %s, %s", res, __FILE__, __LINE__, message1, message2); \
        perror(perror_buffer);                                                                            \
    }

#define ON_ERROR_RET_VOID(res, message1, message2) \
    ON_ERROR(res, message1, message2);             \
    if (res < 0)                                   \
        return;

#define ON_ERROR_RET(res, message1, message2, retval) \
    ON_ERROR(res, message1, message2);                \
    if (res < 0)                                      \
        return retval;

typedef enum
{
    GPO0 = 0,
    GPO1 = 1,
    GPO2 = 2,
    GPO3 = 3,
    GPO4 = 4,
    GPO5 = 5,
    GPO6 = 6,
    GPO7 = 7
} gpo_pin_enum_t;

typedef enum
{
    GPI0 = 8,
    GPI1 = 9,
    GPI2 = 10,
    GPI3 = 11,
    GPI4 = 12,
    GPI5 = 13,
    GPI6 = 14,
    GPI7 = 15
} gpi_pin_enum_t;

typedef enum
{
    GPIO_VALUE_LOW = 0,
    GPIO_VALUE_HIGH = 1
}gpio_value_enum_t;


int is_file_exist(const char *file_path);
extern char perror_buffer[];
extern char *gpio_value_file_gpo_list[];
extern char *gpio_pin_str[];
extern int gpio_pin_str_len[];
extern char *gpio_pin_value_str[];
extern int gpo_value_fd[];
extern int gpio_pin_value_str_len[];
void print_array(int *array, int count);

#endif