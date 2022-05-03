interface i2c_if(input ref_clk);
  
  // SDA as tri 1 so that it defaults to 1, when driven Z
  tri1 SDA;

  // SCL as WOR such that it does or of all the drivers.
  // useful in clock stretching
  wor SCL;

  assign SCL = ref_clk;

endinterface : i2c_if
