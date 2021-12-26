.global delay_us
.func delay_us
delay_us:
    cmp r0, #0
    moveq pc, lr
    stmfd	sp!, {r1, r2, fp, lr}
    mov r1, r0
    big_loop:
        ldr r2, =266
        loop:
            sub r2, r2, #1
            cmp r2, #0
            bne loop
        sub r1, r1, #1
        cmp r1, #0
        bne big_loop
    ldmfd	sp!, {r1, r2, fp, pc}
.endfunc
