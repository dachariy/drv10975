// I2C Defines

// Spec Page 42
`define I2C_SLAVE_ADDRESS 7'b101_0010

// 1KHZ : 1000us | 10khz : 100us | 1MHZ : 1us 
`define I2C_CLK_PERIOD_US 100

// Delay in terms of refclk. Min 3
// Delay - SDA_FOR_START_OR_STOP - DELAY
`define I2C_DELAY 3
