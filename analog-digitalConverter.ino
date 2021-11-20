/*
este codigo esta diseñado con el fin de revisar cuales son las salidas de los analogos seleccionados para poder hacer los comandos de subir, bajar y dejar la raqueta estatica en el juego que se 
está diseñando
*/
const int analog1 = A1;  // Puerto analogico donde se encuetnra conectado el eje x del joystick
const int analog2 = A0;  // Puerto analogico donde se encuetnra conectado el eje Y del joystick
const int bit1 =12;   
const int bit2 =13;
const int bit3 =10;   
const int bit4 =11;


int sensorValue1 = 0;        // value read from the 1 joystick
int sensorValue2 = 0;        // value read from the 2 joystick

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  pinMode(bit1,OUTPUT);
  pinMode(bit2,OUTPUT);
  pinMode(bit3,OUTPUT);
  pinMode(bit4,OUTPUT);
  pinMode(analog1,INPUT);
  pinMode(analog2,INPUT);
}
void loop() {
  // read the analog in value:
  sensorValue1 = analogRead(analog1);
  sensorValue2 = analogRead(analog2);
  // print the results to the Serial Monitor:
  Serial.print("sensor 2 = ");
  Serial.print(sensorValue1); 
  Serial.print("        sensor 1 = ");
  Serial.print(sensorValue2);
  Serial.println();
  delay(50);

  if(sensorValue1 >=0 & sensorValue1 <=341)
  {
    digitalWrite(bit1,HIGH);
    digitalWrite(bit2, HIGH);
    Serial.print("bit 1=  1");
    Serial.print("  bit 2=  1");
    Serial.println();
    
    }
    if(sensorValue1 >341 & sensorValue1 <=682){
    digitalWrite(bit1,HIGH);
    digitalWrite(bit2, LOW);
    Serial.print("bit 1=  1");
    Serial.print("  bit 2=  0");
    Serial.println();
    }
    if(sensorValue1 >682 & sensorValue1 <=1024){
    digitalWrite(bit1,LOW);
    digitalWrite(bit2, LOW);
    Serial.print("bit 1=  0");
    Serial.print("  bit 2=  0");
    Serial.println();
    }
    
  if(sensorValue2 >=0 & sensorValue2 <=341)
  {
    digitalWrite(bit3,HIGH);
    digitalWrite(bit4, HIGH);
    Serial.print("bit 3=  1");
    Serial.print("  bit 4=  1");
    Serial.println();
    
    }
    if(sensorValue2 >341 & sensorValue2 <=682){
    digitalWrite(bit3,HIGH);
    digitalWrite(bit4, LOW);
    Serial.print("bit 3=  1");
    Serial.print("  bit 4=  0");
    Serial.println();
    }
    if(sensorValue2 >682 & sensorValue2 <=1024){
    digitalWrite(bit3,LOW);
    digitalWrite(bit4, LOW);
    Serial.print("bit 3=  0");
    Serial.print("  bit 4=  0");
    Serial.println();
    } 
}
