// int request[105] = {
//   90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171
//   };


// void setup() {
//   Serial.begin(9600);
//   uint16_t CRC = 0xFFFF;
//   for (int i = 0; i < 103; i++) {
//     CRC ^= request[i];
//     for (int j = 0; j < 8; j++) {
//       if (CRC & 0x01) {
//         CRC = (CRC >> 1) ^ 0x8408;
//       }
//       else {
//         CRC >>= 0x01;
//       }
//     }
//   }
//   uint16_t CRC_txd = (~CRC) & 0xFFFF;

//   Serial.println((CRC_txd >> 8) & 0xFF);
//   Serial.println(CRC_txd & 0xFF);
// }

// void loop() {

// }