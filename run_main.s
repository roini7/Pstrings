    .section .rodata
string_format: .string "%s"
decimal_format:.string "%d"

    .text
    .globl run_main
    .type run_main, @function
run_main:
        ## init stack
    pushq   %rbp
    movq    %rsp, %rbp

	    ## allocate 256 bytes for pstring1 string and 8 bytes for pstring1 length in stack
	subq    $272, %rsp
	leaq    (%rsp), %rsi
	movq    $decimal_format , %rdi
	movq    $0, %rax
	call    scanf
	leaq    1(%rsp), %rsi
	movq    $string_format, %rdi
    movq    $0, %rax
    call    scanf
        ## allocate 256 bytes for pstring2 string and 8 bytes for pstring2 length in stack
	subq    $272, %rsp
	leaq    (%rsp), %rsi
	movq    $decimal_format , %rdi
	movq    $0, %rax
	call    scanf
	leaq    1(%rsp), %rsi
	movq    $string_format, %rdi
    movq    $0, %rax
    call    scanf
        ## allocate 32 bytes for user numeric input for function select
        ## extra bytes are for stack alignment (16 byte aligned)
    subq    $32, %rsp
    leaq    (%rsp), %rsi
    movq    $decimal_format, %rdi
    movq    $0, %rax
    call    scanf

        ## pass input stored in stack as arguments to func_select
    movq    (%rsp), %rax
    movzbq  %al, %rdi
    leaq    304(%rsp), %rsi
    leaq    32(%rsp), %rdx
        ## call function select with passed arguments
    call    run_func
    addq    $576, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret
