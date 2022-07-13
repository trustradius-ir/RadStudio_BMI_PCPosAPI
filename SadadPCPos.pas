unit SadadPCPos;

interface
uses SysUtils,Classes,Generics.Collections,IdComponent, IdTCPConnection, IdTCPClient,IdGlobal,Forms,IdStack,IdUDPServer,IdSocketHandle;

Const
  Str_ConnectingToPCPos = 'در حال ارتباط با پوز';
  Str_ConnectedToPCPos = 'ارتباط با پوز برقرار شد';
  Str_PCPosReadyForTransaction = 'پوز آماده دریافت دستور پرداخت است';
  Str_TransactionRequested = 'درخواست شروع تراکنش ارسال شد';
  Str_WaitForPosOperation  = 'در انتظار اجرای عملیات توسط کاربر پوز';
  Str_PosOperationDone = 'عملیاتی توسط کاربر پوز انجام شد';
  Str_CanceledByClient = 'تراکنش توسط نرم‌افزار لغو شد';
  Str_CanceledByRemote = 'تراکنش توسط کاربر پوز لغو شد';
  Str_OperationError = 'خطا در اجرای درخواست';
type
  TPacketType = (Stx = 2, Etx = 3, Eot = 4, Ack = 6,Nack = 21,Request= 25,Response = 26,Unkonwn = 27,Inm = 241);
  TPacketStatus = (MsgSizeError,MsgHeaderError,MsgFooterError,MsgLenError,MsgLrcError,MsgInProgressError,MsgSyncError,MsgSuccess);
  TFrameResponse = (NoResponse,ConnectingToPCPos,ConnectedToPCPos,PCPosReadyForTransaction,TransactionRequested,WaitForPosOperation,PosOperationDone,MaxRetry,CanceledByClient,CanceledByRemote,Success,OperationError);
  TMultiMerchantMode = (PercentOld = 2, AmoumtOld = 3, PercentNew = 4, AmountNew = 5);

  TPosResponseData = record
    Amount,ApprovalCode,CardNo,Merchant,OptionalField,PacketType,PcPosStatus,ProccessingCode,ResponseCode,Rrn,
    Terminal,TransactionDate,TransactionNo,TransactionTime:String;
  end;

  TPersianPosDateTime = Record
    PersianDate,PersianTime:String;
  end;

  TSmallInts = Array of SmallInt;
  TMultiMerchantPosDevider = record
    Index:Integer;
    Value:Integer;
  end;

  TPCPosInfo = Record
    Header,MerchantName,IpAddress,Port,TerminalId,MerchantId:String;
    MultiAccount:Boolean;
  End;

  TTotalTPCPosInfo = Array of TPCPosInfo;


  FramePduLen = class
    const Footer = 1;
    const Header = 1;
    const Length = 3;
    const Version = 3;
    const Sync = 1;
    const Lrc = 1;
    const PacketType = 1;
  end;

  TOnPcPosSearchResult = procedure(const PosInfo: TPCPosInfo;const TotalTPCPosInfo:TTotalTPCPosInfo) of object;
  TPcPosSearch = class
    private
      FIdUDPServer:TIdUDPServer;
      FTotalTPCPosInfo:TTotalTPCPosInfo;
      FOnPcPosSearchResult:TOnPcPosSearchResult;
//      procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread;AData: TBytes; ABinding: TIdSocketHandle);
      procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread;const AData: TIdBytes; ABinding: TIdSocketHandle);
    published
      constructor Create;
      destructor Destroy;
      property TotalTPCPosInfo: TTotalTPCPosInfo read FTotalTPCPosInfo;
      property OnPcPosSearchResult: TOnPcPosSearchResult read FOnPcPosSearchResult write FOnPcPosSearchResult;
      function StartPCPosSearch(UPort: Word= 100):Boolean;
      procedure StopPCPosSearch;
  End;

  TPcPosPacket = class
    private
      FAmount:string;
      FFunctionCode:string;
      FInvoiceNumber:string;
      FMessageType:string;
      FProccessingCode:string;
      FBitmap:Byte;
      FPacketType:Byte;
      FOpt1:String;
      FOpt2:String;
      FOpt3:String;
      FOpt4:String;
      FOpt5:String;
      FOpt6:String;
      FOpt7:String;
      FOpt8:String;
      function GetAmount: string;
      procedure SetAmount(Value: string);
      function GetFunctionCode: string;
      procedure SetFunctionCode(Value: string);
      function GetInvoiceNumber: string;
      procedure SetInvoiceNumber(Value: string);
      function GetMessageType: string;
      procedure SetMessageType(Value: string);
      function GetProccessingCode: string;
      procedure SetProccessingCode(Value: string);
      function GetOpt1: string;
      procedure SetOpt1(Value: string);
      function GetOpt2: string;
      procedure SetOpt2(Value: string);
      function GetOpt3: string;
      procedure SetOpt3(Value: string);
      function GetOpt4: string;
      procedure SetOpt4(Value: string);
      function GetOpt5: string;
      procedure SetOpt5(Value: string);
      function GetOpt6: string;
      procedure SetOpt6(Value: string);
      function GetOpt7: string;
      procedure SetOpt7(Value: string);
      function GetOpt8: string;
      procedure SetOpt8(Value: string);

      property PacketType:Byte read FPacketType write FPacketType;
      property FunctionCode: string read GetFunctionCode write SetFunctionCode;
      property MessageType: string read GetMessageType write SetMessageType;
      property ProccessingCode: string read GetProccessingCode write SetProccessingCode;
      property Opt1: string read GetOpt1 write SetOpt1;
      property Opt2: string read GetOpt2 write SetOpt2;
      property Opt3: string read GetOpt3 write SetOpt3;
      property Opt4: string read GetOpt4 write SetOpt4;
      property Opt5: string read GetOpt5 write SetOpt5;
      property Opt6: string read GetOpt6 write SetOpt6;
      property Opt7: string read GetOpt7 write SetOpt7;
      property Opt8: string read GetOpt8 write SetOpt8;
    published
      constructor Create;
      function ByteArrayToInt16Array(Buffer:TBytes):TSmallInts;
      function GetPersianPosDateTime(Buffer:TSmallInts):TPersianPosDateTime;
      function SerializeRequestData:TBytes;
      function DeSerializeResponseData(inBuffer:TBytes):TPosResponseData;
      property Amount: string read GetAmount write SetAmount;
      property InvoiceNumber: string read GetInvoiceNumber write SetInvoiceNumber;
      procedure SetSaleId(SaleID:String);
      procedure SetBillInfo(BillId,PayID:String);
      procedure SetMultiMerchantsData(MultiMerchantValue:TList<TMultiMerchantPosDevider>;MultiMerchantMode:TMultiMerchantMode);
  end;



  TPcPosConnectionStatus = procedure(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string) of object;
  TPcPosOperationStatus = procedure(const AStatus: TFrameResponse; const AStatusText: string) of object;

  TPcPosMessage = class
    private
      FSerialNo:String;
      FVersion:String;
      FLanIPAddress:String;
      FLanPort:Word;
      FIsHandShakeOn:Boolean;
      FResponseTimeout:Word;
      FConnectTimeout:Word;
      FPosResponseData:TPosResponseData;
      FIdTCPClient: TIdTCPClient;
      FOnConnectionStatus:TPcPosConnectionStatus;
      FOnPcPosOperationStatus:TPcPosOperationStatus;
      FAbortPcPosOperation:Boolean;
      function CalLrc(Buffer:TBytes):Byte;
      function CreatePcPosFrame(inBuffer:TBytes;PacketType:TPacketType):TBytes;
      procedure CheckPcPosFrame(inBuffer:TBytes;var PacketStatus:TPacketStatus;var PacketType:TPacketType;var RecvData:TBytes);
      function IdTCPClientReadData(WaitMiliseconds:Integer = 2000):TIdBytes;
    published
      PcPosPacket:TPcPosPacket;
      constructor Create;
      destructor Destroy;
      function RequestSaleTransaction:TFrameResponse;
      procedure AbortPcPosOperation;
      procedure DoPcPosOperationStatus(const AStatus: TFrameResponse; const AStatusText: string);
      property ResponseTimeout:Word read FResponseTimeout write FResponseTimeout;
      property ConnectTimeout:Word read FConnectTimeout write FConnectTimeout;
      property PosResponseData: TPosResponseData read FPosResponseData write FPosResponseData;
      property SerialNo: string read FSerialNo write FSerialNo;
      property Version: string read FVersion write FVersion;
      property LanIPAddress: string read FLanIPAddress write FLanIPAddress;
      property LanPort: Word read FLanPort write FLanPort;
      property OnPcPosConnectionStatus: TPcPosConnectionStatus read FOnConnectionStatus write FOnConnectionStatus;
      property OnPcPosOperationStatus: TPcPosOperationStatus read FOnPcPosOperationStatus write FOnPcPosOperationStatus;
  end;

implementation

function ToArray(InValue:TList<Byte>):TBytes;
var Value:Byte;
    I:Integer;
begin
  SetLength(Result,InValue.Count);
  I := 0;
  for Value in InValue do
  begin
    Result[I] := Value;
    Inc(I);
  end;
end;

///
/// TPcPosSearch
///


constructor TPcPosSearch.Create;
begin
  Inherited Create;
  FIdUDPServer := TIdUDPServer.Create();
  FIdUDPServer.OnUDPRead := IdUDPServerUDPRead;
  FIdUDPServer.DefaultPort := 100;
end;

destructor TPcPosSearch.Destroy;
begin
  //SetLength(FTotalTPCPosInfo,0);
  //FTotalTPCPosInfo := Nil;
  Try
    FIdUDPServer.Active := False;
    FIdUDPServer.Free;
  Except

  End;
  Inherited;
end;


function TPcPosSearch.StartPCPosSearch(UPort: Word = 100):Boolean;
begin
  Result := False;
  if FIdUDPServer.Active then Exit;
  FIdUDPServer.DefaultPort :=  UPort;
  Try
    FIdUDPServer.Active := True;
    Result := True;
  Except

  End;
end;

procedure TPcPosSearch.StopPCPosSearch;
begin
  Try
    FIdUDPServer.Active := False;
  Except

  End;
end;

//procedure TPcPosSearch.IdUDPServerUDPRead(AThread: TIdUDPListenerThread;AData: TBytes; ABinding: TIdSocketHandle);
procedure TPcPosSearch.IdUDPServerUDPRead(AThread: TIdUDPListenerThread;const AData: TIdBytes; ABinding: TIdSocketHandle);
var RData:String;
    PosList:TStringList;
    NewPcPosInfo,PcPosInfoItem:TPcPosInfo;
    AlreadyFind:Boolean;
begin
  Try
    RData := TEncoding.UTF8.GetString(TBytes(AData));
    PosList := TStringList.Create;
    PosList.StrictDelimiter := True;
    PosList.Delimiter := ':';
    PosList.DelimitedText := RData;
    if PosList.Count <> 6 then
    begin
      PosList.Free;
      Exit;
    end;

    With NewPcPosInfo Do
    begin
      Header := PosList[0]; //Header
      MerchantName := PosList[1]; //MerchantName
      IpAddress := PosList[2]; //IpAddress
      Port := PosList[3]; //Port
      TerminalId := PosList[4]; //TerminalId
      MerchantId := PosList[5]; //MerchantId
      MultiAccount := True;
    end;
    PosList.Free;

    AlreadyFind := False;
    for PcPosInfoItem in FTotalTPCPosInfo do
    begin
      if PcPosInfoItem.IpAddress = NewPcPosInfo.IpAddress then
      begin
        AlreadyFind := True;
        Break;
      end;
    end;
    if not AlreadyFind then
    begin
      SetLength(FTotalTPCPosInfo,Length(FTotalTPCPosInfo)+1);
      FTotalTPCPosInfo[Length(FTotalTPCPosInfo)-1] := NewPcPosInfo;
    end ;

    if Assigned(OnPcPosSearchResult) And not AlreadyFind then
    begin
      OnPcPosSearchResult(NewPcPosInfo,FTotalTPCPosInfo)
    end;
  Except

  End;
end;


///
/// TPcPosPacket
///

constructor TPcPosPacket.Create;
begin
  Inherited Create;

  FAmount := '';
  FFunctionCode := '';
  FInvoiceNumber := '';
  FMessageType := '';
  FProccessingCode := '';
  FBitmap := 0;
  FPacketType := 0;
  FOpt1 := '';
  FOpt2 := '';
  FOpt3 := '';
  FOpt4 := '';
  FOpt5 := '';
  FOpt6 := '';
  FOpt7 := '';
  FOpt8 := '';
end;

function PadRight(InValue:String;PadLength:Integer;PadChar:Char):String;
var I:Integer;
begin
  for I := 1 to PadLength - Length(InValue) do
  begin
    InValue := InValue + PadChar;
  end;
  Result := InValue;
end;

function PadLeft(InValue:String;PadLength:Integer;PadChar:Char):String;
var I:Integer;
begin
  for I := 1 to PadLength - Length(InValue) do
  begin
    InValue := PadChar + InValue;
  end;
  Result := InValue;
end;

//Amount
function TPcPosPacket.GetAmount: string;
begin
  Result := PadRight(FAmount,13,#0);
end;

procedure TPcPosPacket.SetAmount(Value: string);
var TempInt:Int64;
begin
  Value := Trim(Value);
  if not IsNumeric(Value) then Value := '0';
  if not TryStrToInt64(Value,TempInt) then Value := '0';
  FAmount := PadRight(Value,13,#0);
end;

//FunctionCode
function TPcPosPacket.GetFunctionCode: string;
begin
  Result := PadRight(FFunctionCode,4,' ');
end;

procedure TPcPosPacket.SetFunctionCode(Value: string);
begin
  FFunctionCode := PadRight(Value,4,' ');
end;

//InvoiceNumber
function TPcPosPacket.GetInvoiceNumber: string;
begin
  Result := PadRight(FInvoiceNumber,10,' ');
end;

procedure TPcPosPacket.SetInvoiceNumber(Value: string);
begin
  FInvoiceNumber := PadRight(Value,10,' ');
end;

//MessageType
function TPcPosPacket.GetMessageType: string;
begin
  Result := PadRight(FMessageType,4,' ');
end;

procedure TPcPosPacket.SetMessageType(Value: string);
begin
  FMessageType := PadRight(Value,4,' ');
end;

//ProccessingCode
function TPcPosPacket.GetProccessingCode: string;
begin
  Result := PadRight(FProccessingCode,6,' ');
end;

procedure TPcPosPacket.SetProccessingCode(Value: string);
begin
  FProccessingCode := PadRight(Value,6,' ');
end;


//Opt1
function TPcPosPacket.GetOpt1: string;
begin
  Result := FOpt1;
end;

procedure TPcPosPacket.SetOpt1(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt1 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 1;
end;

//Opt2
function TPcPosPacket.GetOpt2: string;
begin
  Result := FOpt2;
end;

procedure TPcPosPacket.SetOpt2(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt2 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 2;
end;

//Opt3
function TPcPosPacket.GetOpt3: string;
begin
  Result := FOpt3;
end;

procedure TPcPosPacket.SetOpt3(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt3 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 4;
end;


//Opt4
function TPcPosPacket.GetOpt4: string;
begin
  Result := FOpt4;
end;

procedure TPcPosPacket.SetOpt4(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt4 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 8;
end;

//Opt5
function TPcPosPacket.GetOpt5: string;
begin
  Result := FOpt5;
end;

procedure TPcPosPacket.SetOpt5(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt5 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 16;
end;

//Opt6
function TPcPosPacket.GetOpt6: string;
begin
  Result := FOpt6;
end;

procedure TPcPosPacket.SetOpt6(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt6 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 32;
end;

//Opt7
function TPcPosPacket.GetOpt7: string;
begin
  Result := FOpt7;
end;

procedure TPcPosPacket.SetOpt7(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt7 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 64;
end;

//Opt8
function TPcPosPacket.GetOpt8: string;
begin
  Result := FOpt8;
end;

procedure TPcPosPacket.SetOpt8(Value: string);
var OpLen:Integer;
begin
  OpLen := Length(Value);
  FOpt8 := PadLeft(IntToStr(OpLen),3,' ') + Value;
  FBitmap := FBitmap or 128;
end;

//SetSaleId
procedure TPcPosPacket.SetSaleId(SaleID:String);
var TempInt:Int64;
begin
  SaleID := Trim(SaleID);
  if not IsNumeric(SaleID) then SaleID := '';
  if (Length(SaleID) = 0) then Exit;
  if Length(SaleID) > 40 then Exit;
  Opt2 := SaleID;
end;

//SetBillInfo
procedure TPcPosPacket.SetBillInfo(BillId,PayID:String);
begin
  if (Length(BillId) = 0) Or (Length(PayID) = 0) then Exit;
  Opt3 := BillId+','+PayID;
end;


//SetMultiMerchantsData
procedure TPcPosPacket.SetMultiMerchantsData(MultiMerchantValue:TList<TMultiMerchantPosDevider>;MultiMerchantMode:TMultiMerchantMode);
var TempStr:String;
    MultiMerchantPosDevider:TMultiMerchantPosDevider;
    StringBuilder:TStringBuilder;
begin
  TempStr := '';
  StringBuilder := TStringBuilder.Create;
  case MultiMerchantMode of
    PercentOld:
    Begin
      TempStr := Concat(TempStr,IntToStr(Byte(MultiMerchantMode)));
      TempStr := TempStr + Format('%.2d',[MultiMerchantValue.Count]);
      for MultiMerchantPosDevider in MultiMerchantValue do
      begin
        StringBuilder.Append('1');
        StringBuilder.Append(Format('%.2d',[MultiMerchantPosDevider.Index]));
        StringBuilder.Append(Format('%.2d',[MultiMerchantPosDevider.Value]));
        TempStr := TempStr + StringBuilder.ToString;
        StringBuilder.Clear;
      end;
      Opt1 := TempStr;
    End;
    AmoumtOld:
    Begin
      TempStr := Concat(TempStr,IntToStr(Byte(MultiMerchantMode)));
      TempStr := TempStr + Format('%.2d',[MultiMerchantValue.Count]);
      for MultiMerchantPosDevider in MultiMerchantValue do
      begin
        StringBuilder.Append('1');
        StringBuilder.Append(Format('%.2d',[MultiMerchantPosDevider.Index]));
        StringBuilder.Append(Format('%.12d',[MultiMerchantPosDevider.Value]));
        TempStr := TempStr + StringBuilder.ToString;
        StringBuilder.Clear;
      end;
      Opt1 := TempStr;
    End;
    PercentNew:
    Begin
      TempStr := Concat(TempStr,IntToStr(Byte(MultiMerchantMode)));
      TempStr := TempStr + Format('%.2d',[MultiMerchantValue.Count]);
      for MultiMerchantPosDevider in MultiMerchantValue do
      begin
        StringBuilder.Append('1');
        StringBuilder.Append(Format('%.4d',[MultiMerchantPosDevider.Index]));
        StringBuilder.Append(Format('%.3d',[MultiMerchantPosDevider.Value]));
        TempStr := TempStr + StringBuilder.ToString;
        StringBuilder.Clear;
      end;
      Opt1 := TempStr;
    End;
    AmountNew:
    Begin
      TempStr := Concat(TempStr,IntToStr(Byte(MultiMerchantMode)));
      TempStr := TempStr + Format('%.2d',[MultiMerchantValue.Count]);
      for MultiMerchantPosDevider in MultiMerchantValue do
      begin
        StringBuilder.Append('1');
        StringBuilder.Append(Format('%.4d',[MultiMerchantPosDevider.Index]));
        StringBuilder.Append(Format('%.12d',[MultiMerchantPosDevider.Value]));
        TempStr := TempStr + StringBuilder.ToString;
        StringBuilder.Clear;
      end;
      Opt1 := TempStr;
    End;
  end;
  StringBuilder.Free;
end;

//SerializeRequestData
function TPcPosPacket.SerializeRequestData:TBytes;
  function OpRow(I:Integer):Byte;
  begin
    Result := 0;
    case I of
      1: Result := Result Or 1;
      2: Result := Result Or 2;
      3: Result := Result Or 4;
      4: Result := Result Or 8;
      5: Result := Result Or 16;
      6: Result := Result Or 32;
      7: Result := Result Or 64;
      8: Result := Result Or 128;
    end;
  end;
var List: TList<Byte>;
    I:Integer;
begin
  List := TList<Byte>.Create;
  List.AddRange(TEncoding.ASCII.GetBytes(Amount));
  List.AddRange(TEncoding.ASCII.GetBytes(InvoiceNumber));
  List.AddRange(TEncoding.ASCII.GetBytes(FunctionCode));
  List.AddRange(TEncoding.ASCII.GetBytes(MessageType));
  List.AddRange(TEncoding.ASCII.GetBytes(ProccessingCode));
  List.Add(FBitmap);
  for I := 1 to 8 do
  begin
    if (FBitmap and OpRow(I)) = OpRow(I) then
    begin
      case I of
        1:List.AddRange(TEncoding.ASCII.GetBytes(Opt1));
        2:List.AddRange(TEncoding.ASCII.GetBytes(Opt2));
        3:List.AddRange(TEncoding.ASCII.GetBytes(Opt3));
        4:List.AddRange(TEncoding.ASCII.GetBytes(Opt4));
        5:List.AddRange(TEncoding.ASCII.GetBytes(Opt5));
        6:List.AddRange(TEncoding.ASCII.GetBytes(Opt6));
        7:List.AddRange(TEncoding.ASCII.GetBytes(Opt7));
        8:List.AddRange(TEncoding.ASCII.GetBytes(Opt8));
      end;
    end
  end;
  FBitmap := 0;
  Result := ToArray(List);
end;

function TPcPosPacket.GetPersianPosDateTime(Buffer:TSmallInts):TPersianPosDateTime;
begin
  Result.PersianDate := Format('%.4d/%.2d/%.2d', [Buffer[0]-24,Buffer[1]-24,Buffer[3]-24]);
  Result.PersianTime := Format('%.2d:%.2d:%.2d', [Buffer[4]-24,Buffer[5]-24,Buffer[6]-24]);
end;

function TPcPosPacket.ByteArrayToInt16Array(Buffer:TBytes):TSmallInts;
var I,J:Integer;
begin
  SetLength(Result,8);
  I := 0;
  J := 0;
  while I <= 15 do
  begin
    Move(Buffer[I], Result[J], SizeOf(SmallInt));
    Inc(I,2);
    Inc(J);
  end;
end;

function TPcPosPacket.DeSerializeResponseData(inBuffer:TBytes):TPosResponseData;
var UnicodeBuffer:WideString;
    PersianPosDateTime:TPersianPosDateTime;
    LTransactionTime:TBytes;
begin
  UnicodeBuffer := TEncoding.Unicode.GetString(inBuffer);
  Result.ResponseCode := Trim(Copy(UnicodeBuffer,1,4));
  Result.Amount := Trim(Copy(UnicodeBuffer,5,13));
  Result.CardNo := Trim(Copy(UnicodeBuffer,18,17));
  Result.ProccessingCode := Trim(Copy(UnicodeBuffer,35,7));
  Result.TransactionNo := Trim(Copy(UnicodeBuffer,42,7));

  LTransactionTime := TBytes(Copy(inBuffer,108,16)); //Read From Buffer no Unicode
  PersianPosDateTime := GetPersianPosDateTime(ByteArrayToInt16Array(LTransactionTime));
  Result.TransactionDate := PersianPosDateTime.PersianDate;
  Result.TransactionTime := PersianPosDateTime.PersianTime;

  Result.Rrn := Trim(Copy(UnicodeBuffer,63,13));
  Result.ApprovalCode := Trim(Copy(UnicodeBuffer,76,7));
  Result.Terminal := Trim(Copy(UnicodeBuffer,83,9));
  Result.Merchant := Trim(Copy(UnicodeBuffer,92,16));
  Result.OptionalField := Trim(Copy(UnicodeBuffer,108,30));
end;

////
///    TPcPosMessage
///

	
constructor TPcPosMessage.Create;
begin
  Inherited;
  FSerialNo := '';
  FVersion := '000';
  FLanIPAddress := '127.0.0.1';
  FLanPort := 8888;
  FIsHandShakeOn := False;
  FConnectTimeout := 5000;
  FResponseTimeout := 60000;
  With FPosResponseData Do
  begin
    Amount := '';
    ApprovalCode := '';
    CardNo := '';
    Merchant := '';
    OptionalField := '';
    PacketType := '';
    PcPosStatus := '';
    ProccessingCode := '';
    ResponseCode := '';
    Rrn := '';
    Terminal := '';
    TransactionDate := '';
    TransactionNo := '';
    TransactionTime := '';
  end;
  FIdTCPClient := TIdTCPClient.Create(Nil);
  PcPosPacket := TPcPosPacket.Create;
end;

destructor TPcPosMessage.Destroy;
begin
  AbortPcPosOperation;
  FIdTCPClient.Disconnect;
  FIdTCPClient.Free;
  PcPosPacket.Free;
  Inherited Destroy;
end;

function TPcPosMessage.CalLrc(Buffer:TBytes):Byte;
var  BufLen,BufValue,I:Integer;
begin
  BufLen := Length(Buffer);
  BufValue := 0;
  for I := 0 to BufLen - 1 do
  begin
    BufValue := Byte(BufValue xor Buffer[I]);
  end;
  BufValue := BufValue xor 3;
  Result := BufValue and 255;
end;



function TPcPosMessage.CreatePcPosFrame(inBuffer:TBytes;PacketType:TPacketType):TBytes;
var Nums1: TList<Byte>;
    RetArray:TBytes;
    FrameLen:Integer;
begin
  Nums1 := TList<Byte>.Create;
  if FVersion = '001' then
  begin

  end
  else if not (FVersion = '000') then
  begin
    RetArray := ToArray(Nums1);
  end
  else
  begin
    Nums1.Add(Byte(TPacketType.Stx));
    FrameLen := FramePduLen.Version + FramePduLen.Lrc + FramePduLen.Footer + FramePduLen.Footer + Length(inBuffer) ;
    Nums1.AddRange(TEncoding.ASCII.GetBytes(PadLeft(IntToStr(FrameLen),FramePduLen.Length,#48)));
    Nums1.AddRange(TEncoding.ASCII.GetBytes(Version));
    Nums1.Add(Byte(PacketType));
    Nums1.AddRange(inBuffer);
    Nums1.Add(Byte(TPacketType.Etx));
    Nums1.Add(CalLrc(Copy(ToArray(Nums1),FramePduLen.Header,FramePduLen.Length + FramePduLen.Version + FramePduLen.PacketType + Length(inBuffer))));
    Result := ToArray(Nums1);
  end;
  Nums1.Free;
end;

procedure TPcPosMessage.CheckPcPosFrame(inBuffer:TBytes;var PacketStatus:TPacketStatus;var PacketType:TPacketType;var RecvData:TBytes);
var PacketLen:Integer;
    Version:String;        
    RPacketType:Byte;
begin
  PacketStatus := MsgSyncError;
  PacketType := Unkonwn;

  //Message Size
  if Length(inBuffer) = 0 then
  begin
    PacketStatus := MsgSyncError;
    PacketType := Unkonwn;
    Exit;
  end;
  
  //Message Header Error
  if inBuffer[0] <> Byte(TPacketType.Stx) then
  begin
    PacketStatus := MsgHeaderError;
    PacketType := Unkonwn;
    Exit;
  end;
  
  //Message Packet Size
  if not TryStrToInt(TEncoding.ASCII.GetString(Copy(inBuffer,FramePduLen.Header, FramePduLen.Length)),PacketLen) Then
  begin
    PacketStatus := MsgSizeError;
    PacketType := Unkonwn;
    Exit;
  end;
  
  //Message Footer Error
  if inBuffer[FramePduLen.Header + FramePduLen.Length + PacketLen - FramePduLen.Footer - FramePduLen.Lrc] <> Byte(TPacketType.Etx) then  
  begin
    PacketStatus := MsgFooterError;
    PacketType := Unkonwn;
    Exit;
  end;

  //Message Lrc Error
  if inBuffer[FramePduLen.Header + FramePduLen.Length + PacketLen - FramePduLen.Footer] <> CalLrc(TBytes(Copy(InBuffer,FramePduLen.Header, PacketLen + FramePduLen.Length - FramePduLen.Lrc - FramePduLen.Footer))) then
  begin
    PacketStatus := MsgLrcError;
    PacketType := Unkonwn;
    Exit;
  end;

  Version := TEncoding.ASCII.GetString(Copy(inBuffer,FramePduLen.Header + FramePduLen.Length, FramePduLen.Version));
  if Version = '300' then FIsHandShakeOn := True else FIsHandShakeOn := False;

  RPacketType := inBuffer[FramePduLen.Header + FramePduLen.Length + FramePduLen.Version];
  if (RPacketType < Byte(Low(TPacketType))) OR  (RPacketType > Byte(High(TPacketType))) then
  begin
    PacketStatus := MsgLrcError;
    PacketType := Unkonwn;
    Exit;
  end;  
  
  case RPacketType of
    2:begin
        PacketStatus := MsgSuccess;
        PacketType := Stx;
      end;
    3:begin
        PacketStatus := MsgSuccess;
        PacketType := Etx;
      end;
    4:begin
        PacketStatus := MsgSuccess;
        PacketType := Eot;
      end;
    6:begin
        PacketStatus := MsgSuccess;
        PacketType := Ack;
      end;
    21:begin
        PacketStatus := MsgSuccess;
        PacketType := Nack;
      end;
    25:begin
        PacketStatus := MsgSuccess;
        PacketType := Request;
        RecvData := TBytes(Copy(inBuffer,FramePduLen.Header + FramePduLen.Length + FramePduLen.Version + FramePduLen.PacketType, PacketLen - FramePduLen.PacketType - FramePduLen.Version));
      end;
    26:begin
        PacketStatus := MsgSuccess;
        PacketType := Response;
        RecvData := TBytes(Copy(inBuffer,FramePduLen.Header + FramePduLen.Length + FramePduLen.Version + FramePduLen.PacketType, PacketLen - FramePduLen.PacketType - FramePduLen.Version));
      end;
  241:begin
        PacketStatus := MsgSuccess;
        PacketType := Inm;
        RecvData := TBytes(Copy(inBuffer,FramePduLen.Header + FramePduLen.Length + FramePduLen.Version + FramePduLen.PacketType, PacketLen - FramePduLen.PacketType - FramePduLen.Version));
      end;
      else
      begin
        PacketStatus := MsgLrcError;
        PacketType := Unkonwn;
      end;
  end;
end;

procedure TPcPosMessage.AbortPcPosOperation;
var inBuffer:TBytes;
    PcPosFrame,RecvBuffer:TIdBytes;
    PacketStatus:TPacketStatus;
    PacketType:TPacketType;
    RecvData:TBytes;
begin
  if FIdTCPClient.Connected then
  begin
    PcPosFrame := TIdBytes(CreatePcPosFrame(inBuffer,TPacketType.Eot));
    Try
      FIdTCPClient.IOHandler.Write(PcPosFrame);
      FIdTCPClient.Disconnect;
    Except

    End;
    FAbortPcPosOperation := True;
  end;
end;

procedure TPcPosMessage.DoPcPosOperationStatus(const AStatus: TFrameResponse; const AStatusText: string);
var StatusText:String;
begin
  if Assigned(OnPcPosOperationStatus) then
  begin
    case AStatus of
      ConnectingToPCPos: StatusText := Str_ConnectingToPCPos;
      ConnectedToPCPos:StatusText := Str_ConnectedToPCPos;
      PCPosReadyForTransaction:StatusText := Str_PCPosReadyForTransaction;
      TransactionRequested:StatusText := Str_TransactionRequested;
      WaitForPosOperation:StatusText := Str_WaitForPosOperation;
      PosOperationDone:StatusText := Str_PosOperationDone;
      CanceledByClient:StatusText := Str_CanceledByClient;
      CanceledByRemote:StatusText := Str_CanceledByRemote;
      OperationError:StatusText := Str_OperationError;
    end;
    if Length(StatusText) = 0 then
      StatusText := AStatusText
    else  if Length(AStatusText) > 0 then
      StatusText := StatusText + ' ['+AStatusText+']';

    OnPcPosOperationStatus(AStatus,StatusText)
  end;
end;

function TPcPosMessage.IdTCPClientReadData(WaitMiliseconds:Integer = 2000):TIdBytes;
var RecvBuffer:TIdBytes;
    WaitCounter:Integer;
begin
  FIdTCPClient.IOHandler.ReadTimeout := 10;
  SetLength(Result,0);
  WaitCounter := 0;
  Repeat
    if FIdTCPClient.Connected then
      FIdTCPClient.IOHandler.ReadBytes(Result,-1,False)
    else
      Break;
    Inc(WaitCounter,FIdTCPClient.IOHandler.ReadTimeout);
    if WaitCounter >= WaitMiliseconds then Break;
    Application.ProcessMessages;
  Until Length(Result) > 0;
end;

function TPcPosMessage.RequestSaleTransaction:TFrameResponse;
var inBuffer:TBytes;
    PcPosFrame,RecvBuffer:TIdBytes;
    PacketStatus:TPacketStatus;
    PacketType:TPacketType;
    RecvData:TBytes;
    Temp:String;
begin

  Result := NoResponse;
  FIdTCPClient.OnStatus := FOnConnectionStatus;
  FIdTCPClient.Host := FLanIPAddress;
  FIdTCPClient.Port := FLanPort;
  FIdTCPClient.ConnectTimeout := FConnectTimeout;
  FAbortPcPosOperation := False;
  try
    Result := ConnectingToPCPos; //در حال ارتباط با پوز
    DoPcPosOperationStatus(Result,'');
    FIdTCPClient.Connect;
    if FIdTCPClient.Connected then
    begin
      Result := ConnectedToPCPos; //ارتباط با پوز برقرار شد
      DoPcPosOperationStatus(Result,'');
      //Request INM Frame
      PcPosFrame := TIdBytes(CreatePcPosFrame(inBuffer,TPacketType.Inm));
      FIdTCPClient.IOHandler.Write(PcPosFrame);
      FIdTCPClient.IOHandler.WriteBufferFlush;
      RecvBuffer := IdTCPClientReadData(FConnectTimeout);
      if Length(RecvBuffer) > 0 then
      begin
        Result := PCPosReadyForTransaction; //پوز آماده دریافت دستور پرداخت است
        DoPcPosOperationStatus(Result,'');
        CheckPcPosFrame(TBytes(RecvBuffer),PacketStatus,PacketType,RecvData);
        //ACK Accept
        if (PacketStatus = MsgSuccess) and (PacketType =  Ack)  then
        begin
          //Request SaleTransaction
          PcPosPacket.MessageType := '0200';
          PcPosPacket.ProccessingCode := '000000';
          inBuffer := PcPosPacket.SerializeRequestData;
          PcPosFrame := TIdBytes(CreatePcPosFrame(inBuffer,TPacketType.Request));
          FIdTCPClient.IOHandler.Write(PcPosFrame);
          FIdTCPClient.IOHandler.WriteBufferFlush;
          Result := TransactionRequested; //درخواست شروع تراکنش ارسال شد
          DoPcPosOperationStatus(Result,'');
          RecvBuffer := IdTCPClientReadData(FConnectTimeout);
          if Length(RecvBuffer) > 0 then
          begin
            CheckPcPosFrame(TBytes(RecvBuffer),PacketStatus,PacketType,RecvData);
            //ACK Accept
            if (PacketStatus = MsgSuccess) and (PacketType =  Ack)  then
            begin
              Result := WaitForPosOperation; //در انتظار اجرای عملیات توسط کاربر پوز
              DoPcPosOperationStatus(Result,'');

              //Wait For Response Frame
              RecvBuffer := IdTCPClientReadData(ResponseTimeout);
              if Length(RecvBuffer) > 0 then
              begin
                CheckPcPosFrame(TBytes(RecvBuffer),PacketStatus,PacketType,RecvData);

                Result := PosOperationDone; //عملیات توسط کاربر پوز انجام شد
                DoPcPosOperationStatus(Result,'');

                if (PacketStatus = MsgSuccess) and (PacketType =  Eot)  then
                begin
                  Result := CanceledByRemote;//عملیات توسط کاربر پوز لغو شد
                  DoPcPosOperationStatus(Result,'');
                end;

                if (PacketStatus = MsgSuccess) and (PacketType =  Response)  then
                begin
                  PosResponseData := PcPosPacket.DeSerializeResponseData(RecvData);
                  Result := Success; //تراکنش با موفقیت انجام شد
                  DoPcPosOperationStatus(Result,'');
                end;
              end
              else
              begin
                if FAbortPcPosOperation Then
                begin
                  Result := CanceledByClient; //عملیات توسط نرم‌افزار لغو شد
                  DoPcPosOperationStatus(Result,'');
                end
                  else
                begin
                  Result := OperationError; //خطا در اجرای عملیات
                  AbortPcPosOperation;
                  DoPcPosOperationStatus(Result,'در زمان تعیین شده درخواستی از سمت کاربر پوز دریافت نشد');
                end;
              end;
            end
            else
            begin
              Result := OperationError; //خطا در اجرای درخواست
              DoPcPosOperationStatus(Result,'درخواست تراکنش توسط پوز رد شد');
            end;
          end
          else
          begin
            Result := OperationError; //خطا در اجرای درخواست
            DoPcPosOperationStatus(Result,'پوز درخواست را رد کرد');
          end;
        end
        else
        begin
          Result := OperationError; //خطا در اجرای درخواست
          DoPcPosOperationStatus(Result,'پوز درخواست را رد کرد');
        end;
      end
      else
      begin
        Result := OperationError; //خطا در اجرای درخواست
        DoPcPosOperationStatus(Result,'پوز به درخواست پاسخ نمی‌دهد');
      end;
    end
    else
    begin
      Result := OperationError; //خطا در اجرای درخواست
      DoPcPosOperationStatus(Result,'امکان ارتباط با پوز وجود ندارد');
    end;
  except
    on E: Exception  do
    begin
      Result := OperationError;
      DoPcPosOperationStatus(Result,E.Message);
    end
  end;
end;

end.

