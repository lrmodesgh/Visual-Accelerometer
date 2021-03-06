Visual-Accelerometer
====================

My Accelerometer Hands-on Project to emulate it with Processing environment.

### Learning Resources :

1. :information_source:		[Accelerometer in Wikipedia](https://en.wikipedia.org/wiki/Accelerometer)
2. :information_source:		[Degrees of Freedom in Wikipedia](https://en.wikipedia.org/wiki/Degrees_of_freedom_%28mechanics%29)
3. :information_source:		[Stewart Platform in Wikipedia](https://en.wikipedia.org/wiki/Stewart_platform)
4. :cool:	[Motion Dynamics Project](http://www.fullmotiondynamics.com/)

### Tools Required :

1. Arduino Microcontroller Platform
2. Arduino Integrated Development Environment
3. Processing Creative Design Environment
4. Processing Libraries : ControlP5

### Instructions :

1. Connect the Arduino Prototyping Hardware (I used Arduino Mega 2560) with the Accelerometer as shown in the `Related Resources` section below
2. Download the Arduino program (accelerometer.ino) from the local repository (downloaded directory) into the Target Arduino board (_I used a Arduino Mega2560 Board_)
3. Invoke the Processing Environment
4. Install the library ControlP5 from `Sketch -> Add Library` Menu
5. Connect Arduino and the Computer running Processing Application with USB Cable
6. Run the Processing Application
7. Browse the Tabs displayed in the Processing Application window and play with it

### Project Related Resources :

1. Accelerometer and Arduino Board Connections ![Accelerometer & Arduino Board Connections](/Accelerometer_bb.png)
2. Accelerometer and Arduino Schematic Diagram ![Accelerometer & Arduino Schematic Diagram](/Accelerometer_schem.png)
3. Accelerometer and Arduino PCB Routed Result ![Accelerometer & Arduino PCB Routed Result](/Accelerometer_pcb.png)

### Uses :

1. Learn Degrees Of Freedom partially.
2. Accelerometer *Data Visualization*
3. Understand how microcontroller is communicating with an Application.
4. Used to understand Accelerometer before constructing **Stewart Platform**
5. Used to construct **Image Stabilizing** system.

### Possible Modifications:

1. Add  MEMS Accelerometer with higher Degrees Of Freedom, MEMS Gyroscope, MEMS Inertial Measurement Unit to spice up the project more.
2. Use Socket, Node, and other JS to experiment, experience and enjoy the web layer.
3. Learn Calibration and contribute the calibration module in Accelerometer application.

