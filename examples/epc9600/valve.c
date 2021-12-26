/**
 * @file valve.c
 * @brief Operate the valveboard with Linux application
 * @details Call valve_init() paired with valve_deinit() as their names imply, valve_send() can be executed several times to operate up to 6 valveboards between valve_init() and valve_deinit()
 * @mainpage github.com/NanjingForestryUniversity
 * @author miaow
 * @email 3703781@qq.com
 * @version v0.9.0
 * @date 2021/12/25 merry christmas
 */

#include <valve.h>
#include <gpio_common.h>
#include <pthread.h>
#include <unistd.h>


// Write to the file desc (global variable `gpo_value_fd` in gpio_common.c) to operate a gpio.
// So gpo_value_fd should be initialized in valve_init with great care.
// Also, gpo_value_fd/gpi_value_fd is used in other .c files (read pluse of encoder, etc).
#define __GPO_SET_BIT(pin_t) __GPO_SET(pin_t, GPIO_VALUE_HIGH)
#define __GPO_CLR_BIT(pin_t) __GPO_SET(pin_t, GPIO_VALUE_LOW)
#define __GPO_SET(pin_t, value_t) write(gpo_value_fd[GPIO_PINDEF_TO_INDEX(pin_t)], gpio_pin_value_str[GPIO_VALUEDEF_TO_INDEX(value_t)], gpio_pin_value_str_len[GPIO_VALUEDEF_TO_INDEX(value_t)])

typedef struct
{
    int need_send; // Set this variable to 1 will cause a packet of sending
    pthread_mutex_t need_send_mutex;
    uint64_t data[6];                // Encoded data for sending
    pthread_mutex_t data_mutex;      // don't use, use need_send_mutex instead
    int need_exit;                   // loop_thread joins to parent-thread at need_exit==1
    pthread_mutex_t need_exit_mutex; // don't use, use need_send_mutex instead
    pthread_t loop_thread;           // The sending thread
    pthread_cond_t is_sending;
} valve_global_t;

static valve_global_t _global_structure;
valve_pin_enum_t valveboard_x_sdata[] = {VALVE_SDATA_1, VALVE_SDATA_2, VALVE_SDATA_3, VALVE_SDATA_4, VALVE_SDATA_5, VALVE_SDATA_6};

static const int _delay = 1000 / SCLK_FREQUENCE_KHZ + 1;
static const int _delay_on_2 = 500 / SCLK_FREQUENCE_KHZ + 1;

extern int delay_us(int us);
void *loop_thread_func(void *param);

/**
 * @brief Initialize valve-related gpos and start loop_thread which keeps communicating with valveboards, SEN/SCLK/SDATA1/SDATA2/SDATA3/SDATA4/SDATA5/SDATA6
 * @return 0 - success, -1 - error
 */
int valve_init()
{
    //打开GPIO
    int fd_export = open(GPIO_EXPORT_PATH, O_WRONLY);
    ON_ERROR_RET(fd_export, GPIO_EXPORT_PATH, "export in valve_init()", -1);
    for (int i = 0; i < 8; i++)
    {
        if (is_file_exist(gpio_value_file_gpo_list[i]))
            continue;
        int ret = write(fd_export, gpio_pin_str[i], gpio_pin_str_len[i]);
        ON_ERROR_RET(ret, gpio_pin_str[i], "open value file in valve_init()", -1);
    }
    for (int i = 0; i < 8; i++)
    {
        gpo_value_fd[i] = open(gpio_value_file_gpo_list[i], O_RDWR);
        ON_ERROR_RET(gpo_value_fd[i], gpio_value_file_gpo_list[i], "open value file in valve_init()", -1);
    }

    close(fd_export);
    pthread_mutex_init(&_global_structure.need_send_mutex, NULL);
    pthread_mutex_init(&_global_structure.data_mutex, NULL);
    pthread_mutex_init(&_global_structure.need_exit_mutex, NULL);
    pthread_cond_init(&_global_structure.is_sending, NULL);

    int ret = pthread_create(&_global_structure.loop_thread, NULL, loop_thread_func, NULL);
    ON_ERROR_RET(ret, "thread create error in valve_init()", "", -1);

    return 0;
}

/**
 * @brief This function runs in child thread and handles communication with valveboard
 */
void *loop_thread_func(void *param)
{
    printf("loop_thread in %s start\r\n", __FILE__);
    int need_exit = 0;
    while (!need_exit)
    {
        pthread_mutex_lock(&_global_structure.need_send_mutex);
        

        if (_global_structure.need_send == 0)
        {
            __GPO_CLR_BIT(VALVE_SCLK);
            
            delay_us(_delay);
            __GPO_SET_BIT(VALVE_SCLK);
            delay_us(_delay);
        }
        else
        {
            delay_us(_delay);
            int i = 48;

            __GPO_SET_BIT(VALVE_SEN);

            while (i--)
            {

                __GPO_CLR_BIT(VALVE_SCLK);
                delay_us(_delay_on_2);
                __GPO_SET(VALVE_SDATA_1, (_global_structure.data[0] & 1UL));
                __GPO_SET(VALVE_SDATA_2, (_global_structure.data[1] & 1UL));
                __GPO_SET(VALVE_SDATA_3, (_global_structure.data[2] & 1UL));
                __GPO_SET(VALVE_SDATA_4, (_global_structure.data[3] & 1UL));
                __GPO_SET(VALVE_SDATA_5, (_global_structure.data[4] & 1UL));
                __GPO_SET(VALVE_SDATA_6, (_global_structure.data[5] & 1UL));
                _global_structure.data[0] >>= 1;
                _global_structure.data[1] >>= 1;
                _global_structure.data[2] >>= 1;
                _global_structure.data[3] >>= 1;
                _global_structure.data[4] >>= 1;
                _global_structure.data[5] >>= 1;
                delay_us(_delay_on_2);
                __GPO_SET_BIT(VALVE_SCLK);
                delay_us(_delay);
            }
            __GPO_CLR_BIT(VALVE_SEN);
            _global_structure.need_send = 0;
            pthread_cond_signal(&_global_structure.is_sending);
        }

        // pthread_mutex_lock(&_global_structure.need_exit_mutex);
        need_exit = _global_structure.need_exit;
        // pthread_mutex_unlock(&_global_structure.need_exit_mutex);
        
        pthread_mutex_unlock(&_global_structure.need_send_mutex);
    }
    printf("loop_thread in %s exit\r\n", __FILE__);
    return NULL;
}

/**
 * @brief Set valve valve in forms of array.
 * @param valve_data An array with size of 6,
 *                   for example, valve_data[0]=64'h0000_FFFF_FFFF_FFFF represents the first valveboard all on
 *                                valve_data[5]=64'h0000_0000_0000_0001 represents the last valveboard turn on its first valve
 * @return 0 - success, -1 - error
 */
int valve_send(uint64_t *valve_data)
{
    pthread_mutex_lock(&_global_structure.need_send_mutex);
    while (_global_structure.need_send == 1)
        pthread_cond_wait(&_global_structure.is_sending, &_global_structure.need_send_mutex);
    
    for (int i = 0; i < 6; i++)
    {
        _global_structure.data[i] = ~valve_data[i]; // 1 represents on in parameter of this function while off when putting data on the bus
    }
    _global_structure.need_send = 1; // Set this variable to 1 will cause a sending packet
    pthread_mutex_unlock(&_global_structure.need_send_mutex);
    return 0;
}

/**
 * @brief Set valve valve in forms of struct.
 * @param valve_data the valve_data struct
 * @return 0 - success, -1 - error
 */
int valve_sendmsg(valvedata_t *valve_data)
{
    pthread_mutex_lock(&_global_structure.need_send_mutex);
    while (_global_structure.need_send == 1)
        pthread_cond_wait(&_global_structure.is_sending, &_global_structure.need_send_mutex);

    _global_structure.data[0] = ~valve_data->valvedata_1; // 1 represents on in parameter of this function while off when putting data on the bus
    _global_structure.data[1] = ~valve_data->valvedata_2;
    _global_structure.data[2] = ~valve_data->valvedata_3;
    _global_structure.data[3] = ~valve_data->valvedata_4;
    _global_structure.data[4] = ~valve_data->valvedata_5;
    _global_structure.data[5] = ~valve_data->valvedata_6;

    _global_structure.need_send = 1; // Set this variable to 1 will cause a sending packet
    pthread_mutex_unlock(&_global_structure.need_send_mutex);
    return 0;
}

/**
 * @brief Deinitialize and turn off all the valve.
 * @param valve_data An array with size of 6,
 *                   for example, valve_data[0]=64'h0000_FFFF_FFFF_FFFF represents the first valveboard all on
 *                                valve_data[5]=64'h0000_0000_0000_0001 represents the last valveboard turn on its first valve
 * @note This function DOES BLOCKS 100000 us at least and DOES NOT UNEXPORT gpos
 * @return 0 - success, -1 - error
 */
int valve_deinit()
{
    uint64_t tmp[6] = {0};
    valve_send(tmp);
    usleep(100000);
    pthread_mutex_lock(&_global_structure.need_send_mutex);
    _global_structure.need_exit = 1;
    pthread_mutex_unlock(&_global_structure.need_send_mutex);
    pthread_join(_global_structure.loop_thread, NULL);
    pthread_mutex_destroy(&_global_structure.need_exit_mutex);
    pthread_mutex_destroy(&_global_structure.need_send_mutex);
    pthread_mutex_destroy(&_global_structure.data_mutex);
    pthread_cond_destroy(&_global_structure.is_sending);
    memset((void *)_global_structure.data, 0, sizeof(_global_structure.data));
    _global_structure.need_exit = 0;
    _global_structure.need_send = 0;

    int ret;
    for (int i = 0; i < 8; i++)
    {
        ret = close(gpo_value_fd[i]);
        ON_ERROR_RET(ret, "close value file in valve_init()", "", -1);
    }
    return 0;
}