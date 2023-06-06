// ESP-32    <--> PN5180 pin mapping:
// 3.3V      <--> 3.3V
// 5v        <--> Vin
// GND       <--> GND
// SCLK, 18   --> SCLK
// MISO, 19  <--  MISO
// MOSI, 23   --> MOSI
// SS, 16     --> NSS (=Not SS -> active LOW)
// BUSY, 5   <--  BUSY
// Reset, 17  --> RST

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <PN5180.h>
#include <PN5180ISO15693.h>
#include <Adafruit_NeoPixel.h>

#define NUM_LEDS 60       // 设置灯带上LED的数量
#define DATA_PIN 13         // 设置灯带数据线连接的ESP32引脚
#define BRIGHTNESS 50       // 设置亮度，范围0-255
#define DELAY_TIME 100      // 设置交替闪烁之间的延迟时间，以毫秒为单位
#define BLINK_TIMES 5       // 设置LED闪烁次数

#if defined(ARDUINO_AVR_UNO) || defined(ARDUINO_AVR_MEGA2560) || defined(ARDUINO_AVR_NANO)

#define PN5180_NSS  10
#define PN5180_BUSY 9
#define PN5180_RST  7

#elif defined(ARDUINO_ARCH_ESP32)

#define PN5180_NSS  16
#define PN5180_BUSY 5
#define PN5180_RST  17

#else
#error Please define your pinout here!
#endif

PN5180ISO15693 nfc(PN5180_NSS, PN5180_BUSY, PN5180_RST);
Adafruit_NeoPixel strip(NUM_LEDS, DATA_PIN, NEO_GRB + NEO_KHZ800);

BLECharacteristic *pCharacteristic;
bool deviceConnected = false;
bool startScanning = false;
uint32_t value = 0;
void blinkLED();
void lightBlueLED();
void lightRedLED();
void LED_show();

enum Mode {
  MODE_NEW_LEARNER,
  MODE_SMART_BUILDER,
  MODE_FREEFORM_ARTISTRY,
  MODE_PUZZLE_MASTER
};

Mode currentMode = MODE_SMART_BUILDER;  // 默认模式为smart builder模式


#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    deviceConnected = true;
  };

  void onDisconnect(BLEServer *pServer) {
    deviceConnected = false;
  }
};
//回掉类处理接收到的数据
class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    //std::string value = pCharacteristic->getValue();
    std::string rxValue = pCharacteristic->getValue();


    if (rxValue.length() > 0) {
      Serial.println("*********");
      Serial.print("Received Value: ");

      for (int i = 0; i < rxValue.length(); i++) {
        Serial.print(rxValue[i]);
      }
      Serial.println();

      if (rxValue == "start") {
        startScanning = true;
      } else if (rxValue == "stop") {
        startScanning = false;
        nfc.reset(); // Reset and disable PN5180
      }else if (rxValue == "completed") {
        // 当接收到完成信号时，闪烁 LED 灯
        blinkLED();
      }else if (rxValue == "newlearner") {
      currentMode = MODE_NEW_LEARNER;
      startScanning = true;
      LED_show();
    } else if (rxValue == "smartbuilder") {
      currentMode = MODE_SMART_BUILDER;
      startScanning = false;
    } else if (rxValue == "freeformartistry") {
      currentMode = MODE_FREEFORM_ARTISTRY;
    } else if (rxValue == "puzzlemaster") {
      currentMode = MODE_PUZZLE_MASTER;
    } else if (rxValue == "correct") {
      // 如果应用程序返回"correct"，则亮蓝灯
      //lightBlueLED();
      LED_show();
    } else if (rxValue == "wrong") {
      // 如果应用程序返回"wrong"，则亮红灯
      lightRedLED();
    }

      Serial.println("*********");}

    // if (value == "start") {
    //   startScanning = true;
    // } else if (value == "stop") {
    //   startScanning = false;
    // }
  }
};

void setup() {
  Serial.begin(115200);
  
  nfc.begin();
  strip.begin();           // 初始化NeoPixel库
  strip.setBrightness(BRIGHTNESS);  // 设置亮度
  strip.show();            // 初始化时，关闭所有像素（LED）

  LED_Turnon();

  BLEDevice::init("Team4");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_WRITE |
    BLECharacteristic::PROPERTY_NOTIFY
  );

  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setCallbacks(new MyCallbacks());

  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(pService->getUUID());
  pAdvertising->start();

  Serial.println("Waiting for a connection...");

  
}


bool errorFlag = false;

// //SLIX2 Passwords, first is manufacture standard
// uint8_t standardpassword[] = {0x0F, 0x0F, 0x0F, 0x0F};
// //New Password
// uint8_t password[] = {0x12, 0x34, 0x56, 0x78};


void loop() {
  if (deviceConnected) {
    Serial.println("device conntected");

    switch (currentMode) {
      case MODE_NEW_LEARNER:{
        // uint8_t uid[8];
        // ISO15693ErrorCode rc = nfc.getInventory(uid);
        // if (ISO15693_EC_OK == rc) {
        //   char uidString[2 * sizeof(uid) + 1];
        //   for (int i = 0; i < 8; i++) {
        //     sprintf(&uidString[i * 2], "%02X", uid[7 - i]);
        //   }

        //   Serial.println(uidString);
        //   Serial.println("");
        //   Serial.print("UID sent via BLE: ");
        //   Serial.println(uidString);
        //   pCharacteristic->setValue(uidString);
        //   pCharacteristic->notify();
        // }
        if(startScanning){
          if (errorFlag) {
          uint32_t irqStatus = nfc.getIRQStatus();

          if (0 == (RX_SOF_DET_IRQ_STAT & irqStatus)) { // no card detected
            Serial.println(F("*** No card detected!"));
          }

          nfc.reset();
          nfc.setupRF();

          errorFlag = false;
          }

          Serial.println(F("----------------------------------"));

          uint8_t uid[8];
          ISO15693ErrorCode rc = nfc.getInventory(uid);
          if (ISO15693_EC_OK != rc) {
            Serial.print(F("Error in getInventory: "));
            errorFlag = true;

            // Turn off all LEDs
            strip.clear();
            strip.show();
          } else {
            // Display LEDs when a card is detected
            //LED_show();
            //blinkLED();
            

            char uidString[2 * sizeof(uid) + 1];
            Serial.print(F("UID= "));
            for (int i = 0; i < 8; i++) {
              //Serial.print(uid[7 - i], HEX); // LSB is first
              sprintf(&uidString[i * 2], "%02X", uid[7 - i]);//-----------------------------------------------
            }
            
            Serial.println(uidString);
            Serial.println("");
            Serial.print("UID sent via BLE: ");
            Serial.println(uidString);
            //delay(10000);
            pCharacteristic->setValue(uidString);
            pCharacteristic->notify();
          }

        }

        
        break;}
      case MODE_SMART_BUILDER:{
        // 执行smart builder模式下的代码
        if(startScanning){
          if (errorFlag) {
          uint32_t irqStatus = nfc.getIRQStatus();

          if (0 == (RX_SOF_DET_IRQ_STAT & irqStatus)) { // no card detected
            Serial.println(F("*** No card detected!"));
          }

          nfc.reset();
          nfc.setupRF();

          errorFlag = false;
          }

          Serial.println(F("----------------------------------"));

          uint8_t uid[8];
          ISO15693ErrorCode rc = nfc.getInventory(uid);
          if (ISO15693_EC_OK != rc) {
            Serial.print(F("Error in getInventory: "));
            errorFlag = true;

            // Turn off all LEDs
            strip.clear();
            strip.show();
          } else {
            // Display LEDs when a card is detected
            LED_show();
            //blinkLED();
            

            char uidString[2 * sizeof(uid) + 1];
            Serial.print(F("UID= "));
            for (int i = 0; i < 8; i++) {
              //Serial.print(uid[7 - i], HEX); // LSB is first
              sprintf(&uidString[i * 2], "%02X", uid[7 - i]);//-----------------------------------------------
            }
            
            Serial.println(uidString);
            Serial.println("");
            Serial.print("UID sent via BLE: ");
            Serial.println(uidString);
            //delay(10000);
            pCharacteristic->setValue(uidString);
            pCharacteristic->notify();
          }

        }
        else{
          delay(1000);

        }
        break;}
      case MODE_FREEFORM_ARTISTRY:{
        nfc.reset(); // 关闭RFID
        break;}
      case MODE_PUZZLE_MASTER:{
        nfc.reset(); // 关闭RFID
        break;}
    }
  }
  else{
    Serial.println("No device conntected");
  }
  
  // if(startScanning){
  //   if (errorFlag) {
  //   uint32_t irqStatus = nfc.getIRQStatus();

  //   if (0 == (RX_SOF_DET_IRQ_STAT & irqStatus)) { // no card detected
  //     Serial.println(F("*** No card detected!"));
  //   }

  //   nfc.reset();
  //   nfc.setupRF();

  //   errorFlag = false;
  //   }

  //   Serial.println(F("----------------------------------"));

  //   uint8_t uid[8];
  //   ISO15693ErrorCode rc = nfc.getInventory(uid);
  //   if (ISO15693_EC_OK != rc) {
  //     Serial.print(F("Error in getInventory: "));
  //     errorFlag = true;

  //     // Turn off all LEDs
  //     strip.clear();
  //     strip.show();
  //   } else {
  //     // Display LEDs when a card is detected
  //     LED_show();
  //     //blinkLED();
      

  //     char uidString[2 * sizeof(uid) + 1];
  //     Serial.print(F("UID= "));
  //     for (int i = 0; i < 8; i++) {
  //       //Serial.print(uid[7 - i], HEX); // LSB is first
  //       sprintf(&uidString[i * 2], "%02X", uid[7 - i]);//-----------------------------------------------
  //     }
      
  //     Serial.println(uidString);
  //     Serial.println("");
  //     Serial.print("UID sent via BLE: ");
  //     Serial.println(uidString);
  //     //delay(10000);
  //     pCharacteristic->setValue(uidString);
  //     pCharacteristic->notify();
  //   }

  // }
  // else{
  //   delay(1000);

  // }

  delay(500);
}

void LED_Turnon(){
  for (int i = 0; i < NUM_LEDS; i++) {
    strip.setPixelColor(i, strip.Color(5, 180, 175));  // 设置LED颜色
    
  }
  strip.show();           // 更新LED显示
  delay(1000);             // 延迟100ms
  strip.clear(); // 关闭所有LED
  strip.show(); 
}

void LED_show() {
  for (int blink = 0; blink < BLINK_TIMES; ++blink) {
    for (int i = 0; i < NUM_LEDS; i += 2) {
      strip.setPixelColor(i, strip.Color(5, 180, 175));  // 设置偶数LED颜色
      if (i + 1 < NUM_LEDS) {
        strip.setPixelColor(i + 1, 0);  // 设置奇数LED关闭
      }
    }
    strip.show();           // 更新LED显示
    delay(DELAY_TIME);      // 延迟

    for (int i = 0; i < NUM_LEDS; i += 2) {
      strip.setPixelColor(i, 0);  // 设置偶数LED关闭
      if (i + 1 < NUM_LEDS) {
        strip.setPixelColor(i + 1, strip.Color(5, 180, 175));  // 设置奇数LED颜色
      }
    }
    strip.show();           // 更新LED显示
    delay(DELAY_TIME);      // 延迟
  }
  strip.clear(); // 关闭所有LED
  strip.show();  // 更新LED显示
}

uint32_t wheel(byte wheelPos) {
  wheelPos = 255 - wheelPos;
  if (wheelPos < 85) {
    return strip.Color(255 - wheelPos * 3, 0, wheelPos * 3);
  }
  if (wheelPos < 170) {
    wheelPos -= 85;
    return strip.Color(0, wheelPos * 3, 255 - wheelPos * 3);
  }
  wheelPos -= 170;
  return strip.Color(wheelPos * 3, 255 - wheelPos * 3, 0);
}

void blinkLED() {
  for (int blink = 0; blink < BLINK_TIMES; ++blink) {
    for (int j = 0; j < 256; j += 32) { // 彩虹色循环，每次增加32，使颜色更加明显
      uint32_t color = wheel(j);
      for (int i = 0; i < NUM_LEDS; i += 2) {
        strip.setPixelColor(i, color); // 设置偶数LED颜色
        if (i + 1 < NUM_LEDS) {
          strip.setPixelColor(i + 1, 0); // 设置奇数LED关闭
        }
      }
      strip.show(); // 更新LED显示
      delay(DELAY_TIME); // 延迟

      for (int i = 0; i < NUM_LEDS; i += 2) {
        strip.setPixelColor(i, 0); // 设置偶数LED关闭
        if (i + 1 < NUM_LEDS) {
          strip.setPixelColor(i + 1, color); // 设置奇数LED颜色
        }
      }
      strip.show(); // 更新LED显示
      delay(DELAY_TIME); // 延迟
    }
  }
  strip.clear(); // 关闭所有LED
  strip.show(); // 更新LED显示
}

void lightBlueLED() {
  strip.fill(strip.Color(0, 0, 255)); // 蓝色
  strip.show();
  delay(1000);
  strip.clear(); // 关闭所有LED
  strip.show(); // 更新LED显示

}

void lightRedLED() {
  strip.fill(strip.Color(255, 0, 0)); // 红色
  strip.show();
  delay(1000);
  strip.clear(); // 关闭所有LED
  strip.show(); // 更新LED显示
}


// void blinkLED() {// light signal for compeleted
//     for (int blink = 0; blink < BLINK_TIMES; ++blink) {
//     for (int i = 0; i < NUM_LEDS; i += 2) {
//       strip.setPixelColor(i, strip.Color(5, 180, 175));  // 设置偶数LED颜色
//       if (i + 1 < NUM_LEDS) {
//         strip.setPixelColor(i + 1, 0);  // 设置奇数LED关闭
//       }
//     }
//     strip.show();           // 更新LED显示
//     delay(DELAY_TIME);      // 延迟

//     for (int i = 0; i < NUM_LEDS; i += 2) {
//       strip.setPixelColor(i, 0);  // 设置偶数LED关闭
//       if (i + 1 < NUM_LEDS) {
//         strip.setPixelColor(i + 1, strip.Color(5, 180, 175));  // 设置奇数LED颜色
//       }
//     }
//     strip.show();           // 更新LED显示
//     delay(DELAY_TIME);      // 延迟
//   }
//   strip.clear(); // 关闭所有LED
//   strip.show();  // 更新LED显示
//   }
// }
