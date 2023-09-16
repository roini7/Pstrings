    .data
null_terminator:    .string "\0"

    .section .rodata
invalid_format:     .string "invalid input!\n"

    .text
    .globl pstrlen
    .type pstrlen, @function
    ## rdi = pstring
pstrlen:
    # init stack
    pushq   %rbp
    movq    %rsp, %rbp
    movq    (%rdi), %rcx
    movzbq  %cl, %rax # save first byte of pstring to return value (which is the length)
    # retrieve stack
    movq    %rbp, %rsp
    popq    %rbp
    ret

    .globl replaceChar
    .type replaceChar, @function
    ## rdi = pstring, rsi = old, rdx = newchar
replaceChar:
    #init stack
    pushq   %rbp
    movq    %rsp, %rbp

    leaq    (%rdi), %r10
    leaq    1(%rdi), %r9 # r9 = &pstring
    movq    $null_terminator, %r8
    movq    (%r8), %rcx

.L1:
    movq    (%r9), %rax
    cmpb    %al, %cl
    je      .L2
    cmpb    %al, %sil
    jne     .L3     # if al != oldchar
    movb    %dl, (%r9) #replace oldchar with newchar
.L3:
    ## move to the next byte on the string
    addq    $1, %r9
    jmp     .L1
.L2:    ## done - reached '\0' terminator
    leaq    (%r10), %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret

    .globl pstrijcpy
    .type pstrijcpy, @function
    ## rdi = &pstring1(dst), rsi = &pstring2(src), rdx = i, rcx = j
pstrijcpy:
    ## init stack
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    movq    %rcx, %rbx

    ## check for invalid input according to the following conditions, if so jump to IV label
    ## i > len(src) or i > len(dst) or j > len(src) or j > len(dst) or i,j < 0 , i > j
    movq    $0, %rax
    cmpq    %rax, %rdx
    js      .LI
    cmpq    %rax, %rcx
    js      .LI

    call    pstrlen
    movq    %rbx, %rcx
    cmpq    %rax, %rdx
    jge      .LI
    cmpq    %rax, %rcx
    jge      .LI
    leaq    (%rdi), %r8
    leaq    (%rsi), %rdi
    call    pstrlen
    movq    %rbx, %rcx
    cmpq    %rax, %rdx
    jge      .LI
    cmpq    %rax, %rcx
    jge      .LI
    cmpq    %rcx, %rdx
    jg      .LI
    jmp     .LV
.LI:
    ## invalid input for (i,j) indexes , printf and ret from func
    movq    $invalid_format, %rdi
    xorq    %rax, %rax
    pushq   $0x41
    call    printf
    movq    $1, %rax
    popq    %rbx
    popq    %rbx
    movq    %rsp, %rbp
    popq    %rbp
    ret
.LV:
    ## copy (i,j) range string from pstring2(src) to pstring1(dst)
    leaq    1(%r13,%rdx), %r8 # src[i]
    leaq    1(%r12,%rdx), %r9 # dst[i]
.S_CPY:
    cmpq    %rcx, %rdx
    jg      .F_CPY
    movb    (%r8), %al
    movb    %al, (%r9)
    addq    $1, %r8
    addq    $1, %r9
    inc     %rdx
    jmp     .S_CPY
.F_CPY:
    ## return pointer to &pstring1(dst) to rax
    leaq    (%r12), %rax
    popq    %rbx
    movq    %rsp, %rbp
    popq    %rbp
    ret

    .globl swapCase
    .type swapCase, @function
    ## rdi = &pstring
swapCase:
    ## init stack
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx

    movq    $0x20, %rbx
    movq    $0, %rax
    leaq    (%rdi), %rcx
    addq    $1, %rdi
.PSTR_S:
    cmpb    (%rdi), %al
    je      .PSTR_E
    movq    $0x41, %rdx
    cmpb    %dl, (%rdi)
    jl      .PSTR_C2
    movq    $0x5A, %rdx
    cmpb    %dl, (%rdi)
    jg      .PSTR_C2
    addb    %bl, (%rdi)
    jmp     .PSTR_NC
.PSTR_C2:
    movq    $0x61, %rdx
    cmpb    %dl, (%rdi)
    jl      .PSTR_NC
    movq    $0x7A, %rdx
    cmpb    %dl, (%rdi)
    jg      .PSTR_NC
    subb    %bl, (%rdi)
.PSTR_NC:
    addq    $1, %rdi
    jmp     .PSTR_S
.PSTR_E:
    leaq    (%rcx), %rax
    popq    %rbx
    movq    %rbp, %rsp
    popq    %rbp
    ret

    .globl pstrijcmp
    .type pstrijcmp, @function
    ## rdi = &pstring1, %rsi = &pstring2, rdx = i, rcx = j
pstrijcmp:
    ## init stack
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    movq    %rcx, %rbx

    ## check for invalid input according to the following conditions, if so jump to IV label
    ## i > len(src) or i > len(dst) or j > len(src) or j > len(dst) or i,j < 0 , i > j
    movq    $0, %rax
    cmpq    %rax, %rdx
    js      .L_INVALID
    cmpq    %rax, %rcx
    js      .L_INVALID

    call    pstrlen
    movq    %rbx, %rcx
    cmpq    %rax, %rdx
    jge     .L_INVALID
    cmpq    %rax, %rcx
    jge     .L_INVALID
    leaq    (%rdi), %r8
    leaq    (%rsi), %rdi
    call    pstrlen
    movq    %rbx, %rcx
    cmpq    %rax, %rdx
    jge     .L_INVALID
    cmpq    %rax, %rcx
    jge     .L_INVALID
    cmpq    %rcx, %rdx
    jg      .L_INVALID
    jmp     .L_VALID
.L_INVALID:
    ## invalid input for (i,j) indexes , printf and ret from func
    movq    $invalid_format, %rdi
    xorq    %rax, %rax
    pushq   $0x41
    call    printf
    movq    $-2, %rax
    addq    $8, %rsp
    popq    %rbx
    movq    %rsp, %rbp
    popq    %rbp
    ret
.L_VALID:
    ## copy (i,j) range string from pstring2(src) to pstring1(dst)
    leaq    1(%r13,%rdx), %r8 # src[i]
    leaq    1(%r12,%rdx), %r9 # dst[i]
    movq    $0, %rax
.PSTRS:
    ## rdi = &pstring1, %rsi = &pstring2, rdx = i, rcx = j
    cmpq    %rcx, %rdx
    jg      .PSTRF
    movzbq  (%r8), %r10
    movzbq  (%r9), %r11
    cmpb    %r10b, %r11b
    jg      .PSTR1
    cmpb    %r11b, %r10b
    jg      .PSTR2
    jmp     .PSTRE
.PSTR1:
    inc     %rax
    jmp     .PSTRE
.PSTR2:
    dec     %rax
    jmp     .PSTRE
.PSTRE:
    inc     %r8
    inc     %r9
    inc     %rdx
    jmp     .PSTRS
.PSTRF:
    ## end of loop
    popq    %rbx
    movq    %rbp, %rsp
    popq    %rbp
    ret