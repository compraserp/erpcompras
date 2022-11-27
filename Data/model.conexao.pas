unit model.conexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  ZConnection, IniFiles;

type

  { TModelConexao }

  TModelConexao = class

    private
      FConexao: TZConnection;
      FPath: String;
      procedure CriaConexao;
      function ReadIniFileStr(Section, Name: String): String;
      procedure WriteIniFileStr(Section, Name, Value: String);
      procedure WriteIniFileStr2(Section, Name, Value: String);

    public

      constructor Create;
      destructor Destroy; Override;

      property FDriverConexao: TZConnection read FConexao write FConexao;
  end;

implementation

{ TModelConexao }

procedure TModelConexao.CriaConexao;
begin
  FPath := ChangeFileExt('config_db','.INI');


  WriteIniFileStr('', '', '');
  FConexao := TZConnection.Create(Nil);

  FConexao.Database        := ReadIniFileStr('db_config', 'database');
  FConexao.HostName        := ReadIniFileStr('db_config', 'hostname');
  FConexao.User            := ReadIniFileStr('db_config', 'user');
  FConexao.Password        := ReadIniFileStr('db_config', 'password');
  FConexao.Protocol        := ReadIniFileStr('db_config', 'protocol');
  FConexao.Port            := StrToInt(ReadIniFileStr('db_config', 'port'));
  FConexao.LibraryLocation := ReadIniFileStr('db_config', 'libraryLocation');
  FConexao.Connected := True;
end;

constructor TModelConexao.Create;
begin
  CriaConexao;
end;

destructor TModelConexao.Destroy;
begin
  FreeAndNil(FConexao);
  inherited Destroy;
end;

procedure TModelConexao.WriteIniFileStr(Section, Name, Value: String);
var
  Fini: TIniFile;
begin
  Fini := TIniFile.Create(FPath);
  try
    FIni.WriteString(Section, Name, Value);
  finally
    Fini.Free;
  end;
end;

procedure TModelConexao.WriteIniFileStr2(Section, Name, Value: String);
var
  Fini: TIniFile;
begin
  Fini := TIniFile.Create(ChangeFileExt(ApplicationName, '.INI'));
  try
    FIni.WriteString(Section, Name, Value);
  finally
    Fini.Free;
  end;
end;

function TModelConexao.ReadIniFileStr(Section, Name: String): String;
var
  Fini: TIniFile;
begin
  Fini := TIniFile.Create(FPath);
  try
    Result := Fini.ReadString(Section, Name, '');
  finally
    Fini.Free;
  end;
end;

end.

