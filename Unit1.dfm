object Form1: TForm1
  Left = 252
  Top = 106
  Width = 915
  Height = 783
  Caption = 'Modulo de mensajes GSM - DEICOM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGridCargav: TDBGrid
    Left = 17
    Top = 121
    Width = 865
    Height = 535
    Align = alClient
    BorderStyle = bsNone
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clMaroon
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    OnCellClick = DBGridCargavCellClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 656
    Width = 899
    Height = 69
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label3: TLabel
      Left = 176
      Top = 8
      Width = 67
      Height = 16
      Caption = 'NUMERO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 158
      Top = 30
      Width = 17
      Height = 16
      Caption = '15'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 22
      Top = 31
      Width = 9
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 32
      Top = 8
      Width = 60
      Height = 16
      Caption = 'C. AREA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 304
      Top = 8
      Width = 72
      Height = 16
      Caption = 'MENSAJE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MemoMsg: TMemo
      Left = 304
      Top = 24
      Width = 329
      Height = 25
      TabOrder = 0
    end
    object eCod: TEdit
      Left = 33
      Top = 28
      Width = 120
      Height = 21
      TabOrder = 1
    end
    object eNum: TEdit
      Left = 176
      Top = 28
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Button5: TButton
      Left = 638
      Top = 24
      Width = 123
      Height = 25
      Caption = 'Enviar'
      TabOrder = 3
      OnClick = Button5Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 899
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 63
      Height = 13
      Caption = 'Fecha FINAL'
    end
    object Label1: TLabel
      Left = 24
      Top = 8
      Width = 70
      Height = 13
      Caption = 'Fecha INICIAL'
    end
    object DateTimePicker1: TDateTimePicker
      Left = 24
      Top = 24
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 41300.6155196991
      Time = 41300.6155196991
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
      OnChange = OnChangEstado
    end
    object CheckBox2: TCheckBox
      Left = 240
      Top = 32
      Width = 137
      Height = 17
      Caption = 'Mensajes RECIVIDOS'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = OnChangEstado
    end
    object CheckBox3: TCheckBox
      Left = 240
      Top = 80
      Width = 121
      Height = 17
      Caption = 'Mensajes ERROR'
      TabOrder = 2
      OnClick = OnChangEstado
    end
    object DateTimePicker2: TDateTimePicker
      Left = 23
      Top = 72
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 41300.6155515741
      Time = 41300.6155515741
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
      OnChange = OnChangEstado
    end
    object CheckBox1: TCheckBox
      Left = 240
      Top = 56
      Width = 129
      Height = 17
      Caption = 'Mensajes ENVIADOS'
      TabOrder = 4
      OnClick = OnChangEstado
    end
    object CheckBox4: TCheckBox
      Left = 240
      Top = 8
      Width = 153
      Height = 17
      Caption = 'Mensajes A ENVIAR'
      TabOrder = 5
      OnClick = OnChangEstado
    end
    object Panel1: TPanel
      Left = 824
      Top = 16
      Width = 49
      Height = 41
      BevelOuter = bvNone
      Caption = '0'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
    object CheckBox5: TCheckBox
      Left = 24
      Top = 100
      Width = 209
      Height = 17
      Caption = 'Refresco AUTOMATICO (20 segundos)'
      TabOrder = 7
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 121
    Width = 17
    Height = 535
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel5: TPanel
    Left = 882
    Top = 121
    Width = 17
    Height = 535
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 784
    Top = 16
    object Archivo2: TMenuItem
      Caption = 'Archivo'
      object Salir1: TMenuItem
        Caption = 'Salir'
        OnClick = Salir1Click
      end
    end
    object Archivo1: TMenuItem
      Caption = 'Puerto'
      object OPENPORT1: TMenuItem
        Caption = 'OPEN PORT'
      end
    end
    object mODULO1: TMenuItem
      Caption = 'Base de Datos'
      object ConfigBD: TMenuItem
        Caption = 'Configurar...'
        OnClick = ConfigBDClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object RunBD1: TMenuItem
        Caption = 'Run BD'
        OnClick = RunBD1Click
      end
    end
  end
  object CtrlModOn: TTimer
    Interval = 5000
    OnTimer = CtrlModOnTimer
    Left = 752
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = ADOQueryMSG
    Left = 56
    Top = 168
  end
  object ADOQueryMSG: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 88
    Top = 168
  end
  object ADOConnection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Proyectos delphi' +
      '\Mod GSM\mensajes.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 120
    Top = 168
  end
  object AQueryMSGaEnviar: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 88
    Top = 200
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Proyectos delphi' +
      '\Mod GSM\mensajes.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 120
    Top = 200
  end
  object TimerCONSULTA: TTimer
    OnTimer = TimerCONSULTATimer
    Left = 720
    Top = 16
  end
  object ADOConnection2: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Proyectos delphi' +
      '\Mod GSM\mensajes.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 120
    Top = 232
  end
  object ADOQueryBorrarMSG: TADOQuery
    Connection = ADOConnection2
    CursorType = ctStatic
    Parameters = <>
    Left = 88
    Top = 232
  end
end
