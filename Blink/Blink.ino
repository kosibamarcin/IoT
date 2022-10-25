extern "C" void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 384;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
  RCC_OscInitStruct.PLL.PLLQ = 8;
  //RCC_OscInitStruct.PLL.PLLR = 2;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
  {
    Error_Handler();
  }
}
#include <SoftwareSerial.h>   
#define rxPin PG9
#define txPin PG14

                                
#define LED1 PC5
#define LED2 PE3
#define LED3 PB12

int value = 0;

#include <SPI.h>
#include <WiFiST.h>

/*
  The following configuration is dedicated to the DISCO L475VG IoT board.
  You should adapt it to your board.
Configure SPI3:
 * MOSI: PC12
 * MISO: PC11
 * SCLK: PC10
Configure WiFi:
 * SPI         : SPI3
 * Cs          : PE0
 * Data_Ready  : PE1
 * reset       : PE8
 * wakeup      : PB13
 */
#define MOSI PB5
#define MISO PB4
#define SCLK PB12
#define CS PG11
#define DATAREADY PG12
#define Reset PH1
#define WakeUp PB15

// SPIClass SPI_3(MOSI, MISO, SCLK, PA15);
// WiFiClass WiFi(&SPI_3, CS, DATAREADY, Reset, WakeUp);

char ssid[] = "DESKTOP-E7013UH3000";                      // the name of your network
char pass[] = "\935qX29";  // your network password
int status = WL_IDLE_STATUS;     // the Wifi radio's status

void setup() {
  // Initialize serial communication and wait for serial port to connect:
  Serial.setTx(txPin);
  Serial.setRx(rxPin);
  Serial.begin(9600);
  while (!Serial) {
    ;
  }

  // // initialize the WiFi module:
  // if (WiFi.status() == WL_NO_SHIELD) {
  //   Serial.println("WiFi module not detected");
  //   // don't continue:
  //   while (true);
  // }

  // // print firmware version:
  // String fv = WiFi.firmwareVersion();
  // Serial.print("Firmware version: ");
  // Serial.println(fv);
  // if (fv != "C3.5.2.5.STM") {
  //   Serial.println("Please upgrade the firmware");
  // }

  // Print WiFi MAC address:
}

void loop() {
  // scan for existing networks every 10 seconds
  Serial.println("Scanning available networks...");
  Serial.flush();
  //listNetworks();
  Serial.println(WiFi.status());
  Serial.flush();
  delay(100);
}

void printMacAddress() {
  // print the MAC address of your Wifi module:
  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  for (uint8_t i = 0; i < 6; i++) {
    if (mac[i] < 0x10) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
    if (i != 5) {
      Serial.print(":");
    } else {
      Serial.println();
    }
  }
}

void listNetworks() {
  // scan for nearby networks:
  Serial.println("** Scan Networks **");
  int numSsid = WiFi.scanNetworks();
  if (numSsid == -1) {
    Serial.println("No WiFi network available");
    while (true);
  }

  // print the list of networks seen:
  Serial.print("Number of available networks: ");
  Serial.println(numSsid);

  // print the network number, name, RSSI and encryption type for each network found:
  for (int thisNet = 0; thisNet < numSsid; thisNet++) {
    Serial.print(thisNet);
    Serial.print(")\tSSID: ");
    Serial.print(WiFi.SSID(thisNet));
    Serial.print("\tRSSI: ");
    Serial.print(WiFi.RSSI(thisNet));
    Serial.print(" dBm");
    Serial.print("\tEncryption: ");
    printEncryptionType(WiFi.encryptionType(thisNet));
  }
  Serial.println();
}

void printEncryptionType(uint8_t encryptionType) {
  // read the encryption type and print out the name:
  switch (encryptionType) {
    case ES_WIFI_SEC_OPEN:
      Serial.println("OPEN");
      break;
    case ES_WIFI_SEC_WEP:
      Serial.println("WEP");
      break;
    case ES_WIFI_SEC_WPA:
      Serial.println("WPA");
      break;
    case ES_WIFI_SEC_WPA2:
      Serial.println("WPA2");
      break;
    case ES_WIFI_SEC_WPA_WPA2:
      Serial.println("WPA_WPA2");
      break;
    case ES_WIFI_SEC_WPA2_TKIP:
      Serial.println("WPA_TKIP");
      break;
    case ES_WIFI_SEC_UNKNOWN:
    default:
      Serial.println("UNKNOWN");
      break;
  }
}

// void setup() {
//   pinMode(PA15, OUTPUT); // set the SS pin as an output
//   SPI.begin();         // initialize the SPI library
//   Serial.setTx(txPin);
//   Serial.setRx(rxPin);
//   Serial.begin(115200);
//   while (!Serial) {
//     ; // wait for serial port to connect. Needed for Leonardo only
//   }
// }

// void loop() {

//   digitalWrite(PA15, LOW);            // set the SS pin to LOW
  
//   for(byte wiper_value = 0; wiper_value <= 128; wiper_value++) {

//     SPI.transfer(0x00);             // send a write command to the MCP4131 to write at registry address 0x00
//     SPI.transfer(wiper_value);      // send a new wiper value

//     Serial.println(analogRead(A0)); // read the value from analog pin A0 and send it to serial
//     delay(1000); 
//   }

//   digitalWrite(PA15, HIGH);           // set the SS pin HIGH
// }


// char ssid[] = "DESKTOP-E7013UH 3000";     //  your network SSID (name)
// char pass[] = "\935qX29";  // your network password
