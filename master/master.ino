#define SQUARE_WAVE_PIN 25

hw_timer_t *timer = NULL;

void handleTimer();

void setup() {
  Serial.begin(115200);
  //Serial.println("Hello!");

  // Initialize the GPIO pin as output
  pinMode(SQUARE_WAVE_PIN, OUTPUT);
  digitalWrite(SQUARE_WAVE_PIN, LOW); // Start with LOW

  // Set timer frequency to 1Mhz
  timer = timerBegin(1000000);
  // Attach onTimer function to our timer.
  timerAttachInterrupt(timer, &handleTimer);
  // Set alarm to call onTimer function every second (value in microseconds).
  // Repeat the alarm (third parameter) with unlimited count = 0 (fourth parameter).
  timerAlarm(timer, 5000, true, 0);
}

void loop() {
static unsigned long lastToggleTime = 0; // Stores the last toggle time
  static bool squareWaveState = false;    // Tracks the square wave state

  // Generate a 1 kHz square wave
  if (micros() - lastToggleTime >= 500) { // 500 us = 1 kHz frequency
    squareWaveState = !squareWaveState;  // Toggle the state
    digitalWrite(SQUARE_WAVE_PIN, squareWaveState); // Set the GPIO pin
    lastToggleTime = micros(); // Update the last toggle time
  }
}

int read_volts;
void handleTimer() {
  read_volts = analogRead(36);
  Serial.printf("%d\n", read_volts);
}