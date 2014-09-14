{{
       heart log
       a logger for your heart
}}

CON
  led_pin = 10
  status_pin = 2
  heart_pin = 3

VAR
  Long is_reset
  Long log_count
  Long log_status
  
OBJ
  system : "Propeller Board of Education"
  sd     : "PropBOE MicroSD"
  pst    : "Parallax Serial Terminal Plus"
  time   : "Timing"

PRI init
  system.Clock(80_000_000)
  log_status := FALSE
  log_count := 0
  is_reset := TRUE
  
  dira[led_pin] := 1
  dira[status_pin] := 1
  dira[heart_pin] := 0
  outa[heart_pin] := 1
  
  repeat 10
    status_on
    led_on
    time.Pause(200)
    status_off
    led_off
    time.Pause(200)
  
PUB go | current_count, tick

  init

  repeat log_count from 0 to 9 '0-10 range limit due to FileName function

    'if toggle
    
    OpenFile(log_count)
     
    '******************** use the first heartbeat to set current_count
    repeat until led_beat 
      time.Pause(10)    
    current_count := cnt    
    '*********************     
    repeat 1000 'change to: while logging
    '1000 @40 bpm = 25 min : @80 bpm =  min : @180 bpm = 5.5 min
     
      repeat until led_beat
        'check if the toggle is pushed
        
        time.Pause(10)
        
      if log_status
        tick := cnt - current_count
        current_count := cnt
         
        if tick > 100_000_000
          tick := 0
        if tick < 1
          tick := 0
         
        'if tick > 1 
        sd.WriteDec(tick)
        sd.WriteByte(13)' Carriage return
        sd.WriteByte(10)' New line
         
      pst.Dec(tick)
      pst.NewLine
      
    CloseFile

PRI logging
  'log_status := TRUE
  
  return log_status
  
PRI OpenFile(log_increment)
  status_on
  sd.Mount(0)
  sd.FileDelete(FileName(log_increment))
  sd.FileNew(FileName(log_increment))
  sd.FileOpen(FileName(log_increment), "W")
  log_status := TRUE
  
  'sd.WriteStr(FileName(log_count))
  'sd.WriteStr(String(13, 10))
  pst.Str(FileName(log_count))
  pst.Str(String(13, 10))
  
    
PRI CloseFile
  sd.FileClose  
  sd.Unmount
  log_status := FALSE
  status_off
       
PRI FileName(x)
  
  'ASCII0_STREngine_1.integerToDecimal(log_count, 2)
  case x
    0 : return String("hrt00.txt")
    1 : return String("hrt01.txt")
    2 : return String("hrt02.txt")
    3 : return String("hrt03.txt")
    4 : return String("hrt04.txt")
    5 : return String("hrt05.txt")
    6 : return String("hrt06.txt")
    7 : return String("hrt07.txt")
    8 : return String("hrt08.txt")
    9 : return String("hrt09.txt")
    10 : return String("hrt10.txt") 
  'return String("hrt1", ".txt")
  'x := String(stringo.integerToDecimal(log_count, 2))
  'return String("hrt", x, ".txt")

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

PRI status_on
  outa[status_pin] := 1
  
PRI status_off
  outa[status_pin] := 0
  
 
      