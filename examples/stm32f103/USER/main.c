#include "delay.h"
#include "led.h"
#include "stdio.h"
#include "sys.h"
#include "usart.h"
#include "valve.h"

int main(void)
{
	uint32_t i = 0;
	delay_init();
	uart_init(115200);
	printf("wdnmd\n");
	uint8_t valve_data[48] = {0};
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
	VALVE_Init();

	while (1)
	{
		i %= 47;
		i++;
		valve_data[i - 1] = 0;
		valve_data[i] = 1;
		VALVE_Send(valve_data);
		delay_ms(100);
	}
}
