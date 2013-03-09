{{

}}
CON
  led_pin = 10
  heart_pin = 3

VAR
  Long is_reset
  
OBJ

  system : "Propeller Board of Education"
  sd     : "PropBOE MicroSD"
  pst    : "Parallax Serial Terminal Plus"
  time   :  "Timing"
  
PUB go | x, y, t, current_count, tick, log_count

  system.Clock(80_000_000)

  dira[led_pin] := 1
  dira[heart_pin] := 0
  outa[heart_pin] := 1 
  {
  repeat 50
    led_beat
    time.Pause(10) 
  }
  log_count := 1
  
  
  sd.Mount(0)
  sd.FileNew(String("hrt", ".txt"))
  sd.FileOpen(String("hrt", ".txt"), "W")
  
  sd.WriteStr(String("Heart Log", 13, 10))
  pst.Str(String("Heart Log", 13, 10))

  current_count := cnt
  is_reset := TRUE
  
  repeat 10
    
    repeat until led_beat
      time.Pause(1)
      
    'time.Pause(10) 'if this is not long enough many zeros will ensue  
    tick := cnt - current_count
    current_count := cnt

    if tick > 80_000_000
      tick := 0
      
    sd.WriteDec(tick)
    sd.WriteByte(13)' Carriage return
    sd.WriteByte(10)' New line
    
    pst.Dec(tick)
    pst.NewLine

  sd.FileClose  
  sd.Unmount  

PRI ToString(thisNumber)

  Case thisNumber
    0 :
      return "0"
    1 :
      return "1"
      
  return "0"
  
PRI led_on
  outa[led_pin] := 1

PRI led_off
  outa[led_pin] := 0

PRI beat
  return ina[heart_pin]

PRI led_beat | what_is
  what_is := beat
  if what_is
    
    if is_reset   
      led_on
      is_reset := FALSE
      return TRUE
    else
      'led_off 'don't turn off the led until the sensor reads low
      what_is := FALSE
      
  else
    is_reset := TRUE
    led_off
  return what_is
  
      