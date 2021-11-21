#include "valve.h"

uint8_t waiting_send = 0;
uint8_t sending = 0;
uint8_t period = 0;
uint8_t *valve_data = 0;
void VALVE_Init()
{
    VALVE_TIM_PERIPHERAL_FUNC(VALVE_TIM_PERIPHERAL, ENABLE);
    VALVE_GPIO_PERIPHERAL_FUNC(VALVE_SCLK_PERIPHERAL | VALVE_SEN_PERIPHERAL | VALVE_SDATA_PERIPHERAL, ENABLE);
    NVIC_InitTypeDef NVIC_InitStructure;
    GPIO_InitTypeDef GPIO_InitStructure;
    TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;

    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStructure.GPIO_Pin = VALVE_SCLK_PIN;
    GPIO_Init(VALVE_SCLK_PORT, &GPIO_InitStructure);
    GPIO_InitStructure.GPIO_Pin = VALVE_SEN_PIN;
    GPIO_ResetBits(VALVE_SEN_PORT, VALVE_SEN_PIN);
    GPIO_Init(VALVE_SEN_PORT, &GPIO_InitStructure);
    GPIO_InitStructure.GPIO_Pin = VALVE_SDATA_PIN;
    GPIO_Init(VALVE_SDATA_PORT, &GPIO_InitStructure);

    TIM_TimeBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
    TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up;
    TIM_TimeBaseInitStructure.TIM_Period = 18000 - 1;
    TIM_TimeBaseInitStructure.TIM_Prescaler = 1 - 1;

    NVIC_InitStructure.NVIC_IRQChannel = VALVE_TIME_IRQN;
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
    NVIC_Init(&NVIC_InitStructure);

    TIM_TimeBaseInit(VALVE_TIM, &TIM_TimeBaseInitStructure);
    TIM_ClearFlag(VALVE_TIM, TIM_IT_Update);
    TIM_ITConfig(VALVE_TIM, TIM_IT_Update, ENABLE);
    TIM_Cmd(VALVE_TIM, ENABLE);
}

ErrorStatus VALVE_Send(uint8_t *valveData)
{
    int timeout = VALVE_COMMUNICATION_TIMEOUT;
    while (sending && --timeout)
        ;
    if (timeout == 0)
        return ERROR;
    waiting_send = 1;
    valve_data = valveData;
    return SUCCESS;
}

void VALVE_TIM_IRQHANDLER()
{
    static uint8_t current_channel = 0;

    if (VALVE_TIM->SR & TIM_IT_Update)
    {
        if (period == 0)
            VALVE_SCLK_PORT->BSRR = VALVE_SCLK_PIN;
        else if (period == 2)
        {
            VALVE_SCLK_PORT->BRR = VALVE_SCLK_PIN;
            if (waiting_send)
            {
                current_channel = 0;
                VALVE_SEN_PORT->BSRR = VALVE_SEN_PIN;
                waiting_send = 0;
                sending = 1;
            }

            if (current_channel == VALVE_CHANNEL_NUM)
            {
                sending = 0;
                VALVE_SEN_PORT->BRR = VALVE_SEN_PIN;
            }
        }
        else if (period == 3 && sending == 1)
        {
            uint32_t tmpreg = VALVE_SDATA_PORT->ODR & ~VALVE_SDATA_PIN;
            VALVE_SDATA_PORT->ODR = tmpreg | (uint16_t)(!valve_data[current_channel] * VALVE_SDATA_PIN);
            current_channel += 1;
        }
        period++;
        period %= 4;
        VALVE_TIM->SR &= ~TIM_IT_Update;
    }
}
