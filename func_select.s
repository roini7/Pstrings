    .section .rodata
    .align 8
length_format: .string "first pstring length: %d, second pstring length: %d\n"
char_format:   .string " %c"
decimal_format:.string "%d"
replace_format:.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
cpy_format:    .string "length: %d, string: %s\n"
cmp_format:    .string "compare result: %d\n"
case_format:   .string "Invalid option!\n"
.L10:
    .quad .L1 # case 31
    .quad .L2 # case 32
    .quad .L2 # case 33
    .quad .L3 # case 34 will jump to default case
    .quad .L4 # case 35
    .quad .L5 # case 36
    .quad .L7 # case 37

    .text
    .globl run_func
    .type run_func, @function
run_func:
    ## rdi = opt rsi = pstring1 rdx = pstring2
    # init stack
    pushq   %rbp
    movq    %rsp, %rbp
    ## callee saved registers for pstring1, pstring2 (for convinience)
    leaq    (%rsi), %r12
    leaq    (%rdx), %r13

    leaq    -31(%rdi), %rax   # align to start from 32 input
    cmpq    $6, %rax   # compare to highest value in switch case
    ja      .L9   # if > 37 jump to default case
    jmp     *.L10(,%rax,8) # otherwise goto jump table and load case

.L1:
    pushq   %rbx
    movq    %rdx, %rbx  #rbx = &pstring2 callee saved
    movq    %rsi, %rdi
    call    pstrlen
    movq    %rax, %rsi
    movq    %rbx, %rdi
    call    pstrlen
    movq    %rax, %rdx
    movq    $length_format, %rdi
    pushq   $0x41
    call    printf
    addq    $8, %rsp
    popq    %rbx
    jmp     .L11
.L2:
        ## storing oldchar and newchar on stack respectively using scanf
    subq    $16, %rsp
    leaq    -16(%rbp), %rsi
    movq    $char_format, %rdi
    movq    $0, %rax
    call    scanf
    leaq    -8(%rbp), %rsi
    movq    $char_format, %rdi
    movq    $0, %rax
    call    scanf
        ## loading arguments rdi = &pstring1 , rsi = oldchar, rdx = newchar to replaceChar func
    leaq    (%r12), %rdi
    leaq    -16(%rbp), %rax
    movq    (%rax), %rsi
    leaq    -8(%rbp), %rax
    movq    (%rax), %rcx
    movzbq   %cl, %rdx
    call    replaceChar
        ## loading arguments rdi = &pstring2 , rsi = oldchar, rdx = newchar to replaceChar func
    leaq    (%r13), %rdi
    call    replaceChar
        ## load arguments to printf
    movq    $replace_format, %rdi
    leaq    1(%r12), %rcx
    leaq    1(%r13), %r8
    xorq    %rax, %rax
    call    printf
    jmp    .L11
.L3:
    jmp     .L9 # 34 -> default case
.L4:
        ## storing i and j indexes on stack respectively using scanf
    subq    $16, %rsp
    leaq    -16(%rbp), %rsi # i will be here
    movq    $decimal_format, %rdi
    movq    $0, %rax
    call    scanf
    leaq    -8(%rbp), %rsi  # j will be here
    movq    $decimal_format, %rdi
    movq    $0, %rax
    call    scanf
        ## loading arguments for pstrijcpy
    leaq    (%r12), %rdi
    leaq    (%r13), %rsi
    leaq    -16(%rbp), %rax
    movq    (%rax), %rdx
    leaq    -8(%rbp), %rax
    movq    (%rax), %r8
    movzbq   %r8b, %rcx
    call    pstrijcpy
        ## check if function call was successful
    movq    $1, %r10
    cmpq    %rax, %r10
    je      .L11
        ## load arguments rdi = cpy_format, rsi = pstring1(dst).length, rdx, = pstring1(dst)
    leaq    (%rax), %rdi
    call    pstrlen
    movq    %rax, %rsi
    leaq    1(%r12), %rdx
    movq    $cpy_format, %rdi
    movq    $0, %rax
    call    printf
    leaq    (%r13), %rdi
    call    pstrlen
    movq    %rax, %rsi
    leaq    1(%r13), %rdx
    movq    $cpy_format, %rdi
    movq    $0, %rax
    call    printf
    jmp     .L11
.L5:
    leaq    (%r12), %rdi
    call    swapCase
    leaq    1(%rax), %rdx
    movzbq  (%rax), %rsi
    movq    $cpy_format, %rdi
    movq    $0, %rax
    call    printf
    leaq    (%r13), %rdi
    call    swapCase
    leaq    1(%rax), %rdx
    movzbq  (%rax), %rsi
    movq    $cpy_format, %rdi
    movq    $0, %rax
    call    printf
    jmp     .L11
.L7:
        ## storing i and j indexes on stack respectively using scanf
    subq    $16, %rsp
    leaq    -16(%rbp), %rsi # i will be here
    movq    $decimal_format, %rdi
    movq    $0, %rax
    call    scanf
    leaq    -8(%rbp), %rsi  # j will be here
    movq    $decimal_format, %rdi
    movq    $0, %rax
    call    scanf
        ## loading arguments for pstrijcmp
    leaq    (%r12), %rdi
    leaq    (%r13), %rsi
    leaq    -16(%rbp), %rax
    movq    (%rax), %rdx
    leaq    -8(%rbp), %rax
    movq    (%rax), %r8
    movzbq   %r8b, %rcx
    call    pstrijcmp
    movq    %rax, %rsi
    movq    $cmp_format, %rdi
    movq    $0, %rax
    call    printf
    jmp     .L11
.L9:    # default case
    movq    $case_format, %rdi
    movq    $0, %rax
    call    printf
.L11:
    # done case
    # retrieve stack
    movq    %rbp, %rsp
    pop     %rbp
    ret


