# Interactive Typing Trainer
This is an interactive typing game based on the website [Monkeytype](monkeytype.com). It is implemented entirely on hardware/firmware, utilizing an [Altera Cyclone FPGA](https://www.altera.com/asap/offering/a1jui000004rocjmac/de2-115-fpga-development-and-education-kit) and an [STM32](https://www.st.com/en/microcontrollers-microprocessors/stm32l4-series.html) microcontroller.
* The system is designed to assess the typing speed of the user based on words per minute (WPM) typed.
* The system can be used offline, in conjunction with a VGA display driven entirely by the FPGA, or as a headless interface utilizing the onboard LCD display and LEDs.
