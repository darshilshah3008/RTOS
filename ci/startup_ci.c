#include <stdint.h>

// Forward declaration
int main(void);

// Minimal vector table + Reset handler for CI link proof.
// Not intended for flashing; just to make GCC link succeed in CI.

__attribute__((section(".isr_vector")))
void (* const g_pfnVectors[])(void) = {
    (void (*)(void)) (0x20008000), // initial stack pointer (dummy)
    (void (*)(void)) ResetISR      // reset handler
};

void ResetISR(void)
{
    // In real firmware you would init .data/.bss and call SystemInit, etc.
    // For CI we just call main.
    (void)main();

    // If main returns, loop forever
    while (1) {}
}
