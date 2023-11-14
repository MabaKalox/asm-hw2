.section .text

.global matmul

matmul:
  // Prologue
  push {r4, r5, r6, r7, r8, r9, r10, r11, r12} // Save register
  // r0 = h1
  // r1 = w1
  // r2 = m1
  // r3 = h2
  ldr r4, [sp, #(0+9*4)] // Get w2
  ldr r5, [sp, #(4+9*4)] // Get m2
  ldr r6, [sp, #(8+9*4)] // Get m3

  mov r7, #0 // k
  mov r8, #0 // j1
  mov r9, #0 // i2
  mov r10, #0 // scratch
  mov r11, #0 // dot_product

  // for each row of m1
loop1:
  cmp r8, r0 // Check if j1 == w2
  beq end1

  mov r9, #0 // Reset i2
  // for each column of m2
loop2:
  cmp r9, r4 // Check if i2 == w2
  beq end2

  mov r7, #0 // Reset i1
  mov r10, #0 // Reset j2
  mov r11, #0 // Init dot product to 0
loop3:
  cmp r7, r1 // Check if k == w1
  beq end3

  // Compute offset into matrix 1: (j1 * w1) + k
  mov r10, r8 // Store j1 into scratch
  mul r12, r10, r1 // Multiply j1 * w1
  mov r10, r12
  add r10, r10, r7 // Add k to j1 * w1

  ldr r12, [r2, r10, LSL#2] // Load m1[(j1 * w1) + k] into scratch 2
  push {r12} // Store scratch2 to the stack

  // Compute offset into matrix 2: (k * w2) + i2
  mov r10, r7 // Store k into scratch
  mul r12, r10, r4 // Multiply k * w2
  mov r10, r12
  add r10, r10, r9 // Add i2 to k * w2

  ldr r12, [r5, r10, LSL#2] // Load m2[(k * w2) + i2] into scratch2
  pop {r10} // Contains m1[(j1 * w1) + k]

  push {r11} // Temporary store current dot_product on stack
  mul r11, r10, r12 // Mul m1[(j1 * w1) + k] by m2[(k * w2) + i2]
  pop {r10} // Restore current dot_product into scratch
  add r11, r11, r10 // Add new mul result to old dot_product

  add r7, r7, #1 // Increment k
  b loop3
end3:
  // Compute offset into out matrix
  mov r10, r8 // Store j1 into scratch
  mul r12, r10, r4 // Multiply j1 * w2
  mov r10, r12
  add r10, r10, r9 // Add i2 to j1 * w2
  str r11, [r6, r10, LSL#2] // store dot_product into out matrix at offset of: (j1 * w2) + i2

  add r9, r9, #1 // Increment i2
  b loop2
end2:

  add r8, r8, #1 // Increment j1
  b loop1
end1:

  mov r0, #0 // Set return status
  // Epilogue
  pop {r4, r5, r6, r7, r8, r9, r10, r11, r12} // Restore registers
  bx lr // return from function
