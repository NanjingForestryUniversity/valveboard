#ifndef __VALVE_INIT_H
#define __VALVE_INIT_H
#include <gpio_common.h>

typedef enum
{
    VALVE_SEN=GPIO_PINDEF_TO_INDEX(GPO1),
    VALVE_SCLK=GPIO_PINDEF_TO_INDEX(GPO2),
    VALVE_SDATA_1=GPIO_PINDEF_TO_INDEX(GPO0),
    VALVE_SDATA_2=GPIO_PINDEF_TO_INDEX(GPO3),
    VALVE_SDATA_3=GPIO_PINDEF_TO_INDEX(GPO4),
    VALVE_SDATA_4=GPIO_PINDEF_TO_INDEX(GPO5),
    VALVE_SDATA_5=GPIO_PINDEF_TO_INDEX(GPO6),
    VALVE_SDATA_6=GPIO_PINDEF_TO_INDEX(GPO7)
}valve_pin_enum_t;

typedef struct
{
    uint64_t valvedata_1;
    uint64_t valvedata_2;
    uint64_t valvedata_3;
    uint64_t valvedata_4;
    uint64_t valvedata_5;
    uint64_t valvedata_6;
} valvedata_t;


#define SCLK_FREQUENCE_KHZ 10000

int valve_init(void);
int valve_send(uint64_t* valve_data);
int valve_deinit(void);
int valve_sendmsg(valvedata_t* valve_data);

#endif