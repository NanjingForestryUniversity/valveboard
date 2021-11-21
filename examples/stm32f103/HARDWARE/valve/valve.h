#ifndef __VALVE_H
#define __VALVE_H

#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "sys.h"

#define VALVE_SCLK_PIN GPIO_Pin_0
#define VALVE_SCLK_PORT GPIOF
#define VALVE_SEN_PIN GPIO_Pin_1
#define VALVE_SEN_PORT GPIOF
#define VALVE_SDATA_PIN GPIO_Pin_2
#define VALVE_SDATA_PORT GPIOF

#define VALVE_TIM TIM6
#define VALVE_TIME_IRQN TIM6_IRQn
#define VALVE_TIM_PERIPHERAL RCC_APB1Periph_TIM6
#define VALVE_TIM_IRQHANDLER TIM6_IRQHandler
#define VALVE_TIM_PERIPHERAL_FUNC RCC_APB1PeriphClockCmd

#define VALVE_GPIO_PERIPHERAL_FUNC RCC_APB2PeriphClockCmd
#define VALVE_SCLK_PERIPHERAL RCC_APB2Periph_GPIOF
#define VALVE_SEN_PERIPHERAL RCC_APB2Periph_GPIOF
#define VALVE_SDATA_PERIPHERAL RCC_APB2Periph_GPIOF

#define VALVE_CHANNEL_NUM 48
#define VALVE_COMMUNICATION_TIMEOUT UINT32_MAX

void VALVE_Init(void);
ErrorStatus VALVE_Send(uint8_t *valveData);

#endif
