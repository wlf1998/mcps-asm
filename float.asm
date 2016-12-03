include \masm32\include\masm32rt.inc

.data?
x real8 ?
a1 real8 ?
a2 real8 ?
a3 real8 ?
r real8 ?
t dw ?

.data
input_format db "%lf%lf%lf%lf",0

.code

start:

call main
inkey
exit

main proc

    invoke crt_scanf,addr input_format,addr x,addr a1,addr a2,addr a3
    fldz
    fld x
    fcompp
    fstsw ax
    fwait
    sahf
    jb err

    fld x
    fsqrt
    fld a1
    fmulp ST(1),ST(0)
    
    fldl2e
    fld x
    fmulp ST(1),ST(0)
    ; stack: x*log2(e)
    fist t
    fild t
    fsubp ST(1),ST(0)
    ; stack: x*log2(e) decimal part
    f2xm1
    fld1
    faddp ST(1),ST(0)
    ; stack: 2^(x*log2(e) decimal part)
    fild t
    fxch
    fscale
    ; stack: x*log2(e) integer part, e^x
    fstp st(1)
    ; stack: e^x
    fld a2
    fmulp ST(1),ST(0)

    fld x
    fsin
    fld a3
    fmulp ST(1),ST(0)

    faddp ST(1),ST(0)
    faddp ST(1),ST(0)

    fst r
    printf("%lf\n",r)
    ret
err:
    printf("Error: x is less than 0!\n")
    ret

main endp

end start