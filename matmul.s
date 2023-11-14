.section .text

.global matmul

matmul:
  push {r4} // Save register
  mov r4, #0 // use r4 as accamulator, set it to 0
  cmp r0, #0
  beq end // Do nothing if we are asked to compute sum of 0
loop:
  add r4, r4, r0 // sum Nth element
  sub r0, r0, #1 // decrement counter, so current n is n-1
  cmp r0, #0
  bne loop // if current n is not 0 yet, continue
end:
  mov r0, #0 // store result into r0
  pop {r4} // Restore registers
  bx lr // return from function
