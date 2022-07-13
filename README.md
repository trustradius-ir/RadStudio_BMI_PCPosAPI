# RadStudio Sadad PCPos API

This API used to connect to BMI Sadad PCPos Without Activex

## Sadad PCPos API Usage


```bash
uses SadadPCPos,...;
```

## Example

```python

type
	...
	private
		procedure OnPcPosConnectionStatus(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
		procedure OnPcPosOperationStatus(const AStatus: TFrameResponse; const AStatusText: string);
		....
	end;


procedure xxxx.OnPcPosConnectionStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
 //EventsAdd(evInfo,AStatus);
end;

procedure xxxx.OnPcPosOperationStatus(const AStatus: TFrameResponse; const AStatusText: string);
begin
 //EventsAdd(evInfo,AStatusText);
end;
	
	

procedure xxxxx.OnClick...
var PcPosMessage:TPcPosMessage;
begin
  PcPosMessage := TPcPosMessage.Create;
  PcPosMessage.OnPcPosConnectionStatus := OnPcPosConnectionStatus;
  PcPosMessage.OnPcPosOperationStatus := OnPcPosOperationStatus;
  PcPosMessage.LanIPAddress := 'x.x.x.x'
  PcPosMessage.LanPort := 8888;
  PcPosMessage.PcPosPacket.Amount := 1000; //example
  //PcPosMessage.PcPosPacket.SetSaleId('1234567890');
  MultiMerchantValue := TList<TMultiMerchantPosDevider>.Create;
  MultiMerchant.Index := 1;
  MultiMerchant.Value := 100;
  MultiMerchantValue.Add(MultiMerchant);
  PcPosMessage.PcPosPacket.SetMultiMerchantsData(MultiMerchantValue,PercentNew);
  FrameResponse := PcPosMessage.RequestSaleTransaction;
  if FrameResponse = Success then
  begin
    With PcPosMessage.PosResponseData Do
    begin
      //EventsAdd(evInfo,'شماره پذیرنده: '+Merchant);
      //EventsAdd(evInfo,'شماره پایانه: '+Terminal);
      //EventsAdd(evInfo,'شماره کارت: '+HideCard(CardNo));
      //EventsAdd(evInfo,'به شماره حساب: '+AccountNumber);
      //EventsAdd(evInfo,'مبغ: '+SDate.CorretMoneyRial(StrToInt(Amount)));
      //EventsAdd(evInfo,'نوع ارسال: '+PacketType);
      //EventsAdd(evInfo,'وضعیت پوز: '+PcPosStatus);
      //EventsAdd(evInfo,'کد پردازش: '+ProccessingCode);
      //EventsAdd(evInfo,'تاریخ تراکنش: '+TransactionDate);
      //EventsAdd(evInfo,'زمان تراکنش: '+TransactionTime);
      //EventsAdd(evInfo,'شماره پیگیری: '+TransactionNo);
      

      IntResponseCode := 9999;
      IntApprovalCode := 0;
      TryStrToInt64(ResponseCode,IntResponseCode);
      TryStrToInt64(ApprovalCode,IntApprovalCode);
      if (IntResponseCode = 0) {And (IntApprovalCode > 0) }then
      begin
          //EventsAdd(evConfirm,'عملیات با موفقیت انجام شد');
          //EventsAdd(evConfirm,'مرجع تراکنش: '+Rrn);
          //EventsAdd(evConfirm,'کد پرداخت: '+ApprovalCode);
      end
      else
      begin
        //EventsAdd(evError,'عملیات ناموفق بود');
        //EventsAdd(evError,'کد پاسخ: '+ResponseCode);
        //EventsAdd(evError,'نتیجه: '+OptionalField);

    end;
  end
  else
  begin
    if FrameResponse = OperationError then
    begin
      //EventsAdd(evError,'پاسخی دریافت نشد - برای اطلاعات بیشتر رسید پوز را بررسی نمایید');
      //EventsAdd(evError,'در صورتی که شرح عملیات موفق بود پرداخت در ۲۴ ساعت آینده');
      //EventsAdd(evError,'به صورت دستی ثبت می‌شود');
    end;
  end;
  Try
    PcPosMessage.Destroy;
  Except

  End;
end;

## License
[MIT](https://choosealicense.com/licenses/mit/)