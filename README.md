# FloatingPointALU

## 32-Bit Floating Point Addition, Subtraction, and Multiplication

This code is part of a final project for which we had to design and synthesize a 32-bit floating point arithmetic unit capable of addition, subtraction, and multiplication.
I designed the adder/subtractor and multiplier, my partner designed the pipelining and communcation from the computer which the processor used for input. 

## Multiplier Design

The core of the multiplier consists of a radix-4 booth recoding scheme and a Wallace tree.
The booth recoding scheme cuts the number of partial products to about half which the Wallace tree then adds to compute the final product.

This multiplier is controlled using a finite state machine with 5 states:

1. Poll for input and load them into the appropiate registers. 

2. Check the input for special cases such as NaN, Inf, or 0; if any are found the output will be known immediately and we
can skip to the output state.

3. Perform the multiplication.

4. Round.

5. Place the output onto a register.

## Adder/Subtractor Design

The main adder module consists of three 8-bit CLA trees that are cascaded together to make a 24 bit adder for the addition of the
mantissas. 

As with the multiplier, the adder is controlled with an FSM, however it consists of 10 states:

1. Poll for input and loads the input into registers.

2. Check for special cases such as NaN, Inf, and 0 which may allow us to skip to the output state.

3. Ensure that the input with the largest absolute value is in the first regsiter, this way if the effective 
operation (EOP) is subtraction we wont end up with a negative output, which we would then have to spend a state negating.

4. Check if the effective operation is subtraction, if it is we negate the smaller input. 

5. Align the mantissas so that addition can be performed.

6. Add the mantissas, got to a normalization state based on the EOP.

7. Nomalization if the EOP was addition.

8. Normalization if the EOP was subtraction.

9. Round.

10. Place output onto a register.
