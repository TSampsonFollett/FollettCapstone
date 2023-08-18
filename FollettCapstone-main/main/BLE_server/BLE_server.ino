/*

This program is intended to be uploaded to an ESP32-WROOM-32E Microcontroller which will act as a bluetooth server with Serial connection to the Follett IM2 Ice Machine Board for reading and writing parameters.

The code below uses ESP32 and Arduino Bluetooth libraries as well as the Vector and Streaming libraries for better containers and printing.

A Bluetooth server works by providing a number of unique bluetooth services to a client (such as an iPhone in this case). 
Usually there will only be one service. Each service contains a number of unique characteristics that hold the data being transferred over bluetooth. 
Each characteristic can hold 10 bytes of data in an array I think. So this can be used to send the bytes of parameters from the IM2 to be reconstructed by the Swift code.


*/

#include <BLEDevice.h> 
#include <BLEUtils.h>
#include <BLEServer.h>
#include <Streaming.h>
#include <Vector.h>

// Used to establish unique BT advertisements
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define mode_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A1"
#define ampsLow_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A2"
#define ampsHigh_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A3"
#define dip_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
#define err_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
#define led1_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
#define led2_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A7"
#define swv_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
#define sn_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A9"
#define phd_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B1"
#define mode24_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B2"
#define augerCurMax_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B3"
// #define augerCurMin_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B4"
// #define augerCurMinEn_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B5"
// #define augerRunOnSb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B6"
// #define augerTDRunOnSb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B7"
// #define binSignalLowHigh_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B8"
// #define callWaterToutSw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26B9"
// #define cleaningBits_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C1"
// #define cleanTimeMb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C2"
// #define compServiceTHw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C3"
// #define compStartupDly_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C4"
// #define dlyAfterPourSb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C5"
// #define dlyBeforeEmptySb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C6"
// #define dlyBeforeRinseSb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C7"
//skip settable dip
// #define displMDlyDur1Tw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C8"
// #define displMDlyDur2Tw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26C9"
// #define displMDlyDur3Tw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D1"
// #define displMDlyDur4Tw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D2"
// #define callWdlyDurMw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D3"
// #define callWdlyMonHb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D4"
// #define callWdis_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D5"
// #define hAmpsdlyDurMw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D7"
// #define hAmpsdlyMonHb_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D8"
// #define hAmpsdis_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26D9"
// #define hPresdlyDurMw_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26E1"

// Define different characteristics for each data.
BLECharacteristic *ampsLow;
BLECharacteristic *ampsHigh;
BLECharacteristic *dipSwitches;
BLECharacteristic *err;
BLECharacteristic *mode;
BLECharacteristic *led1;
BLECharacteristic *led2;
BLECharacteristic *swv;
BLECharacteristic *sn;
BLECharacteristic *phd;
BLECharacteristic *mode24;
BLECharacteristic *augerCurMax;

unsigned long mainMillis = millis(); // Start time
uint8_t counter = 0; // Used to indicate how many cycles have happened
int CRC_txd; // Used to store calculated CRC value when writing to board

const uint8_t numBytes = 189; // The number of bytes the board sends after a read request
const uint16_t MAX_STORAGE = 300; // Used for the 24 hour pie chart to store values every 5 seconds (will be 5 minutes)
const uint8_t NUM_WRITEABLE = 122; // The number of bytes that the writeable parameters take up

//Initializing the vector that will store the 24 hour pie chart data
uint8_t storage[MAX_STORAGE];
Vector<uint8_t> modeDats(storage);

//Initializing the vector that stores the bytes from the read request to the board
byte reply_storage[numBytes];
Vector<byte> reply(reply_storage);

bool addedVal = false; // Used to make sure a value is added to modeDats every 5 seconds with some precision
bool connected = false; // Used to toggle if the bluetooth server is actively looking for clients (probably don't need)

// Inheriting from BLEServerCallbacks to override the onConnect and onDisconnect functions so that the server never stops looking for clients when it's disconnected
class MyServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer *pServer) {
        connected = true;
    }

    void onDisconnect(BLEServer *pServer) {
        connected = false;
        BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
        pAdvertising->addServiceUUID(SERVICE_UUID);
        pAdvertising->setScanResponse(true);
        pAdvertising->setMinPreferred(0x06); // functions that help with iPhone connections issue
        pAdvertising->setMinPreferred(0x12);
        BLEDevice::startAdvertising();
    }
};

// Inheriting from the BLECharacteristicCallbacks class to override the onWrite function to execute code that writes to the IM2 board
class MyCharacteristicCallbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
        // Initializing vector that will contain the bytes to be written to the board
        byte writer[NUM_WRITEABLE]; 
        Vector<byte> bytesToWrite(writer);
        //bytesToWrite.fill(reply);
        //Serial << "Regular array: " << bytesToWrite << endl;
        //Serial << "Received values: " << pCharacteristic->getValue()[0] << " " << pCharacteristic->getValue()[1] << endl;

        // Change the required bytes in the reply vector
        reply[2] = pCharacteristic->getValue()[0]; 
        reply[3] = pCharacteristic->getValue()[1];
        reply[0] = 0x5a;
        reply[1] = 0x01; // 0x01 command for writing parameters to the board without resetting

        // CRC calculation
        uint16_t CRC = 0xFFFF;
        for (int i = 0; i < NUM_WRITEABLE - 2; i++) {
          CRC ^= reply[i];
          for (int j = 0; j < 8; j++) {
            if (CRC & 0x01) {
              CRC = (CRC >> 1) ^ 0x8408;
            }
            else {
              CRC >>= 0x01;
            }
          }
        }
        CRC_txd = (~CRC) & 0xFFFF;

        //The last two bytes are the CRC
        reply[NUM_WRITEABLE - 2] = (CRC_txd >> 8) & 0xFF;
        reply[NUM_WRITEABLE - 1] = CRC_txd & 0xFF;

        bytesToWrite.fill(reply); // put all the bytes into the vector (byte array under the hood) that will be written to the board

        //Serial << "Array to write: " << test << endl;
        //Serial << "Characteristic value written?: " << ((reply[3] << 8) + reply[2]) << endl;
        //Serial << Serial.availableForWrite() << endl;

        Serial.flush(); // Waits until any bytes that are being written to the board are fully written (say if you tried to write from your phone while the ESP32 was trying to send a read request)
        while (Serial.available()) { // Reads any bytes in the serial buffer so that the buffer is completely cleared for use
          Serial.read();
        }

        Serial.write(bytesToWrite.data(), NUM_WRITEABLE); // The bytes are written through the Serial port
        
        delay(250); // To make sure the IM2 has time to read everything and process

        // Same process to wait until Serial connection is completely clear
        Serial.flush();
        while (Serial.available()) {
          Serial.read();
        }
    }
};

void setup()
{
  Serial.begin(14400); // Starting the serial port object at the 14400 baud rate that the board works at
  Serial.setTimeout(250); // ht5
  digitalWrite(17, LOW);  // turns on serial1 output pin.


  Serial.println("Starting BLE work!");
  mainMillis = millis(); // init start time

  BLEDevice::init("Follett Ice Machine"); // Initialize the bluetooth device object with the given title
  BLEServer *pServer = BLEDevice::createServer(); // Create the server object
  pServer->setCallbacks(new MyServerCallbacks()); // Need to set the callbacks, otherwise the server object will use the default ones that don't do what we want
  
  // Create the service abject with the service UUID for identification, 350 handles which store the actual data (extra just in case), and the ID which tells you which service it is on the server
  BLEService *pService = pServer->createService(BLEUUID(SERVICE_UUID), 350, 1); 

  // Intialize Bluetooth Characteristics
  ampsLow = pService->createCharacteristic(
              ampsLow_UUID,
              BLECharacteristic::PROPERTY_READ |
              BLECharacteristic::PROPERTY_WRITE);
  ampsHigh = pService->createCharacteristic(
               ampsHigh_UUID,
               BLECharacteristic::PROPERTY_READ |
               BLECharacteristic::PROPERTY_WRITE);
  dipSwitches = pService->createCharacteristic(
                  dip_UUID,
                  BLECharacteristic::PROPERTY_READ |
                  BLECharacteristic::PROPERTY_WRITE);
  err = pService->createCharacteristic(
          err_UUID,
          BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE);
  mode = pService->createCharacteristic(
           mode_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  led1 = pService->createCharacteristic(
           led1_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  led2 = pService->createCharacteristic(
           led2_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  swv = pService->createCharacteristic(
           swv_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  sn = pService->createCharacteristic(
           sn_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  phd = pService->createCharacteristic(
           phd_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  mode24 = pService->createCharacteristic(
           mode24_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  augerCurMax = pService->createCharacteristic(
           augerCurMax_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  augerCurMax->setCallbacks(new MyCharacteristicCallbacks()); // Set callbacks so that when a write command occurs, it uses our function instead of the default one

  // Start Bluetooth Service
  pService->start(); 
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void loop()
{
  uint8_t minAmp_TS[2]; // Data storage of minAmp values
  uint8_t maxAmp_TS[2]; // Data storage of maxAmp values
  uint8_t swvv[2]; // Data storage of software version
  uint8_t augerCurMax_TS[2]; //Data storage of augerCurMax
  int errv = 0; // Error value
  uint8_t modev = 0; // Mode value
  uint8_t led1v = 0; // LED1 value
  uint8_t led2v = 0; // LED2 value
  char snv[] = {'E', 'R', 'R', 'O', 'R', '?', '\0'}; // Data storage of serial number
  char phdv[] = {'E', 'R', 'R', 'S', '\0'}; // Data storage of phd model

  // Extraction from ice machine
  if (millis() - mainMillis >= 250)
  {
    mainMillis = millis();
    digitalWrite(0, LOW); // led on

    byte request[] = {
      90, 6, 68, 246
    };
    // byte request[] = {
    //   90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    // 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    //0, 0, 152, 171
    // };
    // byte reply[170]; // was 167
    byte data[21];
    // byte data[9];
    byte i;
    bool flag = false;
    // Serial.write(request, 105); // Request information from ice machine and
    while (Serial.available()) {
      Serial.read();
      }
    Serial.write(request, 4);
    unsigned long currentMillis = millis();
    while (!Serial.available())
    {
      if (millis() - currentMillis >= 500)
      {
        flag = true;
        break;
      }
      delay(0);
    }

    // Serial.readBytes(reply, 170); // Write the response to reply array
    Serial.readBytes(reply.data(), 189);
    int testVal = 5;

    if (!flag)
    { // extract informaiton from ice machine
      // condense data
      
      augerCurMax_TS[0] = reply[2];
      augerCurMax_TS[1] = reply[3];
      // maxAmp_TS[0] = reply[144]; // max amp right byte
      // maxAmp_TS[1] = reply[145]; // max amp left byte
      maxAmp_TS[0] = reply[161];
      maxAmp_TS[1] = reply[162];
      // minAmp_TS[0] = reply[146]; // min amp right byte
      // minAmp_TS[1] = reply[147]; // min amp left byte
      minAmp_TS[0] = reply[163];
      minAmp_TS[1] = reply[164];

      swvv[0] = reply[173];
      swvv[1] = reply[174];

      // data[4] = reply[148]; // dipswitches was 145
      data[4] = reply[165];
      // data[6] = reply[153]; // errors lowbyte was 150
      data[6] = reply[170];
      // data[7] = reply[154]; // errors highbyte was 151 // ERROR: Empty
      data[7] = reply[171];
      errv = data[6] + ((int)data[7] << 8);
      // data[8] = reply[155]; // mymode was 152 -- ERROR: empty
      data[8] = reply[172];
      data[9] = reply[173];
      data[10] = reply[174];
      data[11] = reply[103];
      data[12] = reply[104];
      data[13] = reply[105];
      data[14] = reply[106];
      data[15] = reply[107];
      data[16] = reply[108];
      data[17] = reply[115];
      data[18] = reply[116];
      data[19] = reply[117];
      data[20] = reply[118];

      modev = (uint8_t)data[8];
      if (millis() % 5000 > 2500) {
        addedVal = false;
      }
      else if (millis() % 5000 <= 2500 && !addedVal) {
        modeDats.push_back(modev);
        if (!modeDats.empty()) {
          for (size_t i = 0; i < modeDats.size(); ++i) { //work on
            uint8_t mode24_TS[1][2] = {{counter, modeDats.at(i)}};
            mode24->setValue((uint8_t *)mode24_TS, sizeof(mode24_TS) / sizeof(mode24_TS[0]) * 2);
            mode24->notify();
        }
      }
        addedVal = true;
      }
      if (modeDats.size() > 288) {
        modeDats.remove(0);
      }
      //led1v = reply[150];
      //led2v = reply[151];
      led1v = reply[167];
      led2v = reply[168];

      snv[0] = (char)data[11];
      snv[1] = (char)data[12];
      snv[2] = (char)data[13];
      snv[3] = (char)data[14];
      snv[4] = (char)data[15];
      snv[5] = (char)data[16];
      phdv[0] = (char)data[17];
      phdv[1] = (char)data[18];
      phdv[2] = (char)data[19];
      phdv[3] = (char)data[20];
      counter++;
    }
    else
    {
      data[0] = 255;
      data[1] = 255;
      data[2] = 0;
      counter++;
    }

    // Update array
    uint8_t dipSwitches_TS[1][2] = {{(int)data[4]}};
    uint8_t err_TS[1][2] = {{errv}};
    uint8_t mode_TS[1][2] = {{counter, modev}};
    uint8_t led1_TS[1][2] = {{counter, led1v}};
    uint8_t led2_TS[1][2] = {{counter, led2v}};

    // Update advertisment objects and send to BT server to iPhone
    ampsLow->setValue(minAmp_TS, (sizeof(minAmp_TS) / sizeof(minAmp_TS[0]) * 2));
    ampsLow->notify();

    ampsHigh->setValue(maxAmp_TS, (sizeof(maxAmp_TS) / sizeof(maxAmp_TS[0]) * 2));
    ampsHigh->notify();

    dipSwitches->setValue((uint8_t *)dipSwitches_TS, sizeof(dipSwitches_TS) / sizeof(dipSwitches_TS[0]) * 2);
    dipSwitches->notify();

    err->setValue((uint8_t *)err_TS, sizeof(err_TS) / sizeof(err_TS[0]) * 2);
    err->notify();

    mode->setValue((uint8_t *)mode_TS, sizeof(mode_TS) / sizeof(mode_TS[0]) * 2);
    mode->notify();

    led1->setValue((uint8_t *)led1_TS, sizeof(led1_TS) / sizeof(led1_TS[0]) * 2);
    led1->notify();

    led2->setValue((uint8_t *)led2_TS, sizeof(led2_TS) / sizeof(led2_TS[0]) * 2);
    led2->notify();

    swv->setValue(swvv, sizeof(swvv) / sizeof(swvv[0]) * 2);
    swv->notify();

    //if (sizeof(snv) >= 6) {
    sn->setValue(snv);
    sn->notify();
    //}

    //if (sizeof(phdv) >= 4) {
    phd->setValue(phdv);
    phd->notify();
    //}

    augerCurMax->setValue(augerCurMax_TS, (sizeof(augerCurMax_TS) / sizeof(augerCurMax_TS[0]) * 2));
    ampsLow->notify();
  }
  
  delay(1000); //- (millis() - mainMillis));
}
