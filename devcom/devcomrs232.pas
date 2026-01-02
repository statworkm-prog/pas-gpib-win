Unit DevComRS232;

{$mode objfpc}{$H+}

// use interfaces without IUnknown as ancestor, so they don' have reference
// counting, the classes don't need to be derived from TInterfacedObject, and
// there are no strange problems when destroying objects using our classes
{$interfaces corba}

Interface

Uses
  Classes, SysUtils,
  DevCom, Serial;

Type

  { TRS232Communicator }

  (**
   * Communicate to a remote instrument via RS-232 (serial)
   *
   * The method Send always adds a newline (^J) after the message.
   * The method Query() will trim all whitespace of the received message.
   *)
  TRS232Communicator = class(IDeviceCommunicator)
  private
    FHandle  : TSerialHandle;
    FTimeout : LongInt;
    FNewline : ShortString;
  public
    (**
     * Instanciate, open serial device and setup communication parameters
     *
     * @param ADevice    serial device, e.g. '/dev/ttyS0'
     *)
    Constructor Create(ADevice:String; BitsPerSec: LongInt; ByteSize: Integer; Parity: TParityType; StopBits: Integer; Flags: TSerialFlags);
    Destructor  Destroy; override;
    { interface IDeviceCommunicator }
    Procedure Send(St:String);
    Function  Receive : String;
    Function  Query(St:String):String;
    Procedure SetTimeout(ATimeout:LongInt);   // in us
    Function  GetTimeout : Longint;
    property  Newline : ShortString read FNewline write FNewline;
  End;


Implementation
Uses

  {$IFDEF WINDOWS}
  Windows, Winsock, PasGpibUtils;

var
  WSAData: TWSAData;
{ TRS232Communicator }
  {$ELSE}
  BaseUnix, Errors, PasGpibUtils;
  {$ENDIF}

//Helper function to enable SelectRead on windows
{$IFDEF WINDOWS}
 function SelectRead(Sock: LongInt; TimeoutMS: Cardinal): LongInt;
 var
   FDS: TFDSet;
   TV: TTimeVal;
 begin
   FD_ZERO(FDS);
   FD_SET(Sock, FDS);

   TV.tv_sec  := TimeoutMS div 1000;
   TV.tv_usec := (TimeoutMS mod 1000) * 1000;
   // Winsock requires nfds = ignored, so pass 0
   Result := WinSock.select(0, @FDS, nil, nil, @TV)
  end;
{$ENDIF}

Constructor TRS232Communicator.Create(ADevice: String; BitsPerSec: LongInt;ByteSize: Integer; Parity: TParityType; StopBits: Integer; Flags: TSerialFlags);
Begin
  FHandle := SerOpen(ADevice);
  if FHandle < 0 then
    {$IFDEF WINDOWS}
    raise Exception.Create('Cannot open serial device '+ADevice+': ' + 'Winsock error ' + IntToStr(GetLastError));
    {$ELSE}
    raise Exception.Create('Cannot open serial device '+ADevice+': '+StrError(FpGetErrno));
    {$ENDIF}
  SerSetParams(FHandle,BitsPerSec,ByteSize,Parity,StopBits,Flags);
  FTimeout := 100000; // default to 100ms
  FNewline := ^J;
End;

Destructor TRS232Communicator.Destroy;
Begin
  SerClose(FHandle);
  Inherited Destroy;
End;

Procedure TRS232Communicator.Send(St: String);
Begin
  SerWrite(FHandle,St[1],Length(St));
  { send newline }
  if FNewline > '' then
    SerWrite(FHandle,FNewline[1],Length(FNewline));
End;

Function TRS232Communicator.Receive: String;
Var Pos,Len : Integer;
    Waiting : Integer;
Begin
  Pos := 1;
  SetLength(Result,0);
  repeat
    Len := 0;
    Waiting := SelectRead(FHandle,FTimeout);
    if (FTimeout = 0) and (Waiting = 0) then
      Break   // empty result
    else if Waiting = 0 then
      raise Exception.Create('Communication timeout for serial device')  // no data -> timeout
    else if Waiting < 0 then
{$IFDEF UNIX}
      raise Exception.Create('Error while reading from serial device: '+StrError(FpGetErrno));
{$ENDIF}
{$IFDEF WINDOWS}
      raise Exception.Create('Error while reading from serial device: ' +  'Winsock error ' + IntToStr(GetLastError));
{$ENDIF}
    SetLength(Result,Pos-1+1024);
    Len := SerRead(FHandle,Result[Pos],1024);
    if Result[Pos+Len-1] = ^J then Break;
    Pos := Pos + Len;
  Until Len = 0;
  SetLength(Result,Pos+Len-1);
End;

Function TRS232Communicator.Query(St: String): String;
Begin
  Send(St);
  Result := Trim(Receive);
End;

Procedure TRS232Communicator.SetTimeout(ATimeout: LongInt);
Begin
  FTimeout := ATimeout;
End;

Function TRS232Communicator.GetTimeout : Longint;
Begin
  Result := FTimeout;
End;

{$IFDEF WINDOWS}
//winsock requires initialisation
initialization
  if WSAStartup($0202, WSAData) <> 0 then
    raise Exception.Create('WinSock initialization failed.');


finalization
  WSACleanup;
{$ENDIF}

End.

