unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, LCLIntf, LCLType;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    MIMessage: TMenuItem;
    MIChDir: TMenuItem;
    MITerminate: TMenuItem;
    MIInfo: TMenuItem;
    SelDirDiag: TSelectDirectoryDialog;
    TrayMenu: TPopupMenu;
    TrayIcon: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure MIChDirClick(Sender: TObject);
    procedure MIInfoClick(Sender: TObject);
    procedure MIMessageClick(Sender: TObject);
    procedure MITerminateClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmMain: TFrmMain;
  Filepath: String;

implementation

{$R *.lfm}

{ TFrmMain }

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  if SelDirDiag.Execute then
    Filepath := IncludeTrailingPathDelimiter(SelDirDiag.FileName)
  else
    Application.Terminate;
end;

procedure TFrmMain.MIChDirClick(Sender: TObject);
begin
  SelDirDiag.Options := [ofCreatePrompt];
  if SelDirDiag.Execute then
    Filepath := IncludeTrailingPathDelimiter(SelDirDiag.FileName)
end;

procedure TFrmMain.MIInfoClick(Sender: TObject);
begin
  ShowMessage('Screenshot Tool v1.1' + sLineBreak + sLineBreak
    + 'Web: https://return-false.de/archive/846');
end;

procedure TFrmMain.MIMessageClick(Sender: TObject);
begin
  MIMessage.Checked := not MIMessage.Checked;
end;

procedure TFrmMain.MITerminateClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.TrayIconClick(Sender: TObject);
var
  BMP: TBitmap;
  ScreenDC: HDC;
  PNG: TPortableNetworkGraphic;
  Filename: String;
begin
  if (filepath <> '') then
  begin
    BMP := TBitmap.Create;
    ScreenDC := GetDC(0);
    BMP.LoadFromDevice(ScreenDC);
    ReleaseDC(0, ScreenDC);
    PNG := TPortableNetworkGraphic.Create;
    PNG.PixelFormat := pf32bit;
    PNG.Assign(BMP);
    filename := FormatDateTime('yyyy-mm-dd_hh-mm-ss', Now) + '.png';
    PNG.SaveToFile(filepath + Filename);
    BMP.Free;
    PNG.Free;
    if MIMessage.Checked then
    begin
      TrayIcon.BalloonHint := filename;
      TrayIcon.ShowBalloonHint;
    end;
  end;
end;

end.

