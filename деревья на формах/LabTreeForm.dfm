object FTree: TFTree
  Left = 0
  Top = 0
  Caption = 'FTree'
  ClientHeight = 490
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PnlControl: TPanel
    Left = 0
    Top = 424
    Width = 872
    Height = 66
    Align = alBottom
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
    object BRefresh: TButton
      Left = 17
      Top = 9
      Width = 98
      Height = 24
      Align = alCustom
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '
      TabOrder = 0
      OnClick = BRefreshClick
    end
    object ESearch: TEdit
      Left = 153
      Top = 6
      Width = 105
      Height = 21
      Align = alCustom
      TabOrder = 1
      OnKeyPress = ESearchKeyPress
    end
    object BGarbachev: TButton
      Left = 153
      Top = 33
      Width = 105
      Height = 30
      Align = alCustom
      Caption = #1048#1089#1082#1072#1090#1100
      TabOrder = 2
      OnClick = BGarbachevClick
    end
    object BOpen: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1082#1088#1099#1090#1100
      TabOrder = 3
      OnClick = BOpenClick
    end
    object BSave: TButton
      Left = 392
      Top = 8
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 4
      OnClick = BSaveClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1090#1077#1082#1089#1090'|*.txt'
    Left = 840
    Top = 456
  end
end
