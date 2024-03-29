#include "MPU9250.h"

// an MPU9250 object with the MPU-9250 sensor on I2C bus 0 with address 0x68
MPU9250 IMU(Wire,0x68);
int status;

void setup() {
  // serial to display data
  Serial.begin(115200);
  while(!Serial) {}

  // start communication with IMU 
  status = IMU.begin();
  if (status < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU wiring or try cycling power");
    Serial.print("Status: ");
    Serial.println(status);
    while(1) {}
  }
  // setting the accelerometer full scale range to +/-8G 
  IMU.setAccelRange(MPU9250::ACCEL_RANGE_8G);
  // setting the gyroscope full scale range to +/-500 deg/s
  IMU.setGyroRange(MPU9250::GYRO_RANGE_500DPS);
  // setting DLPF bandwidth to 20 Hz
  IMU.setDlpfBandwidth(MPU9250::DLPF_BANDWIDTH_20HZ);
  // setting SRD to 19 for a 50 Hz update rate
  IMU.setSrd(19);
}

void loop() {
  // read the sensor
  IMU.readSensor();

 
  mms();

  delay(100);
}

void mms(){
    // Calculate Roll and Pitch (rotation around X-axis, rotation around Y-axis)

    float Y_out = IMU.getAccelY_mss();
    float X_out = IMU.getAccelX_mss();
    float Z_out = (IMU.getAccelZ_mss())*-1;

    int roll = int(atan(Y_out / sqrt(pow(X_out, 2) + pow(Z_out, 2))) * 180 / PI);
    int pitch = int(atan(-1 * X_out / sqrt(pow(Y_out, 2) + pow(Z_out, 2))) * 180 / PI);

    Serial.print(roll);
    Serial.print("/");
    Serial.println(pitch);
   
    
//    Serial.print(IMU.getAccelX_mss());
//    Serial.print("\t");
//    Serial.print(IMU.getAccelY_mss());
//    Serial.print("\t");
//    Serial.print(IMU.getAccelZ_mss()*-1);
//    Serial.print("\n");
}

void rads(){
    Serial.print(IMU.getGyroX_rads(),6);
    Serial.print("\t");
    Serial.print(IMU.getGyroY_rads(),6);
    Serial.print("\t");
    Serial.print(IMU.getGyroZ_rads(),6);
    Serial.print("\n");
}

void mag(){
   Serial.print(IMU.getMagX_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagY_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagZ_uT(),6);
  Serial.print("\t");
  Serial.println(IMU.getTemperature_C(),6);
}
