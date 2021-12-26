/**
 * @file gpio_common.c
 * @brief Operate the GPIO port of Zhou Ligong linux industrial control board
 * @details is_file_exist(const char *file_path) determine whether the specified file exists
 *          print_array(int *array, int count) used to print out the value of the queue buffer, easy to debug and use
 * @mainpage github.com/NanjingForestryUniversity
 * @author miaow
 * @email 3703781@qq.com
 * @version v0.9.0
 * @date 2021/12/25 merry christmas
 */
#include <gpio_common.h>

char perror_buffer[1024] = {0};

char *gpio_value_file_gpo_list[8] = {GPIO_GET_VALUE_FILE(52), GPIO_GET_VALUE_FILE(53),
                                     GPIO_GET_VALUE_FILE(54), GPIO_GET_VALUE_FILE(55),
                                     GPIO_GET_VALUE_FILE(56), GPIO_GET_VALUE_FILE(57),
                                     GPIO_GET_VALUE_FILE(58), GPIO_GET_VALUE_FILE(59)};

char *gpio_pin_str[8] = {"52", "53", "54", "55", "56", "57", "58", "59"};
int gpio_pin_str_len[8] = {2, 2, 2, 2, 2, 2, 2, 2};
char *gpio_pin_value_str[2] = {"0", "1"};
int gpio_pin_value_str_len[2] = {1, 1};
int gpo_value_fd[8] = {0};

/**
 * @brief determine whether the specified file exists
 * @param file_path file path
 * @return 1 - success, -1 - error
 */
int is_file_exist(const char *file_path)
{
    if (file_path == NULL)
        return -1;
    if (access(file_path, F_OK) == 0)
        return 1;
    return -1;
}

/**
 * @brief Put the processed host computer data into the queue
 * @param array Buffer pointer in the queue
 * @param count The number of data in the buffer
 */
void print_array(int *array, int count)
{
    if (count == 0)
    {
        printf("[]\r\n");
        return;
    }
    printf("[");
    int i;
    for (i = 0; i < count - 1; i++)
    {
        printf("%d,", array[i]);
    }
    printf("%d]\r\n", array[i]);
}
