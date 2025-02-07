#include <LiquidCrystal.h>
#include <SoftwareSerial.h>

// Pin tanımlamaları
#define temp_sens A1
#define heat 7
#define fan 6

float temp_check = 0;
float set_point = 25;  // Set point 25°C

// LCD için pin atamaları (rs, en, d4, d5, d6, d7)
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

// Bluetooth modülü için SoftwareSerial (RX, TX)
// Bluetooth modülünüzün bağlantı pinlerine göre ayarlayın.
SoftwareSerial BTserial(8, 9);

void setup() {
  lcd.begin(16, 2);
  pinMode(temp_sens, INPUT);
  pinMode(heat, OUTPUT);
  pinMode(fan, OUTPUT);

  // Bluetooth ve Serial haberleşme başlatılıyor
  BTserial.begin(9600);  // Modülünüzün baud rate’i (genellikle 9600)
  Serial.begin(9600);    // Debug için Serial Monitor
}

void loop() {
  // Sıcaklık sensöründen okuma yapılıyor
  temp_check = analogRead(temp_sens);
  temp_check = temp_check * 0.48828125;  // Analog değeri sıcaklığa çevirme

  // LCD’nin eskimiş içeriğini temizleyelim
  lcd.clear();
  
  // Isı kontrolü: set point’e göre ısıtma veya soğutma
  if (temp_check < set_point) {
    digitalWrite(heat, HIGH);
    digitalWrite(fan, LOW);
    lcd.print("Heating...");
    BTserial.print("Mode: Heating, ");
  } else if (temp_check > set_point) {
    digitalWrite(heat, LOW);
    digitalWrite(fan, HIGH);
    lcd.print("Cooling...");
    BTserial.print("Mode: Cooling, ");
  } else {
    digitalWrite(heat, LOW);
    digitalWrite(fan, LOW);
    lcd.print("Stable");
    BTserial.print("Mode: Stable, ");
  }
  
  // LCD’ye set point ve mevcut sıcaklık yazdırma
  lcd.setCursor(0, 1);
  lcd.print("Set:");
  lcd.print(set_point);
  lcd.print(" Cur:");
  lcd.print(temp_check);

  // Bluetooth üzerinden verileri gönderme (örneğin, CSV formatında)
  BTserial.print("Set:");
  BTserial.print(set_point);
  BTserial.print(",Cur:");
  BTserial.println(temp_check);

  // Debug için Serial Monitor çıktısı
  Serial.print("Set:");
  Serial.print(set_point);
  Serial.print(", Cur:");
  Serial.println(temp_check);
  
  delay(1000);  // 1 saniyede bir güncelle
}
