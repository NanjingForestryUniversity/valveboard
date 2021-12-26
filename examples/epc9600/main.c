#include <valve.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <math.h>

queue_msg_t queue_msg = {NULL, 1024, 0, 0, 0, 0, 0};
valvedata_t valvedata = {0};
queue_msg_t queue = {0};

#define ROTATE_UINT64_RIGHT(x, n) ((x) >> (n)) | ((x) << ((64) - (n)))
#define ROTATE_UINT64_LEFT(x, n) ((x) << (n)) | ((x) >> ((64) - (n)))

int main(int argc, char *argv[])
{
    uint64_t aaa = (uint64_t)pow(2.0, 48.0);
    printf(motd);
    queue_init(&queue, 1024);
    valve_init();
    valvedata.valvedata_1 = 1;
    for (uint64_t i = 0; i < aaa; i++)
    {
        valvedata.valvedata_1 = i;  // ROTATE_UINT64_RIGHT(valvedata.valvedata_1, 1);
        valve_sendmsg(&valvedata);
    }
    queue_deinit(&queue);
    valve_deinit();
    printf(motd2);
    return 0;
}
