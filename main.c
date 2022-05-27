#include <avr/io.h>

int main(void)
{
	unsigned char tccr0a = 0;
	unsigned char tccr0b = 0;

	// Set PB1 pin direction to "output".
	DDRB |= _BV(PB1);

	// Fast PWM, up to 0xFF.
	tccr0a |= _BV(WGM01) | _BV(WGM00);
	// CLKio/64.
	tccr0b |= _BV(CS01) | _BV(CS00);
	// Set OC0A/OC0B on Compare Match, clear OC0A/OC0B at BOTTOM.
	tccr0a |= _BV(COM0B1) | _BV(COM0B0);

	TCCR0A = tccr0a;
	TCCR0B = tccr0b;

	// Set duty cycle on PB1.
	OCR0B = DUTY_CYCLE;

	// Do nothing.
	while (1) {}
}
