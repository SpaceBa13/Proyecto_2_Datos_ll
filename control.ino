#include <Keyboard.h>

// Definición de los pines de los botones
const int buttonPins[] = {2, 3, 4, 5,6};
const char buttonChars[] = {'w', 'a', 's', 'd',' '};

int buttonStates[5] = {0, 0, 0, 0,0};       // Variable para almacenar el estado actual de los botones
int lastButtonStates[5] = {0, 0, 0, 0,0};   // Variable para almacenar el estado anterior de los botones

void setup() {
  // Inicializa los pines de los botones como entrada
  for (int i = 0; i < 5; i++) {
    pinMode(buttonPins[i], INPUT);
  }
  Serial.begin(9600);
  Keyboard.begin();
}

void loop() {
  // Lee el estado de cada botón
  for (int i = 0; i < 5; i++) {
    buttonStates[i] = digitalRead(buttonPins[i]);

    // Compara el estado actual del botón con el estado anterior
    if (buttonStates[i] == HIGH && lastButtonStates[i] == LOW) {
      // Si el botón está presionado y el estado anterior era no presionado
      Keyboard.press(buttonChars[i]);
      Serial.print("Botón ");
      Serial.print(i + 1);
      Serial.println(" presionado");
    } else if (buttonStates[i] == LOW && lastButtonStates[i] == HIGH) {
      // Si el botón se ha soltado
      Keyboard.release(buttonChars[i]);
      Serial.print("Botón ");
      Serial.print(i + 1);
      Serial.println(" soltado");
    }

    // Actualiza el estado anterior del botón
    lastButtonStates[i] = buttonStates[i];
  }
  // Pequeña pausa para evitar demasiadas lecturas en muy poco tiempo
  delay(50);
}