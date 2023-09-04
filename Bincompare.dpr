program Bincompare;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Diagnostics,
  System.TimeSpan,
  comparefile in 'comparefile.pas',
  progress in 'progress.pas';

var reason : string;
    time : TStopwatch;
    duration : TTimeSpan;
    fsize : int64;
    trans : double;
    mult : string;

begin
  try
    if ParamCount = 2 then begin
        time := TStopwatch.StartNew;
        fsize := compare(paramstr(1), paramstr(2), reason);
        time.Stop;
        duration := time.Elapsed;

        if fsize > 0 then
            writeln(format('File size: %d', [fsize]));
        writeln(reason);
        write(duration.ToString);

        if (fsize > 0) and (duration.TotalSeconds > 0) then begin
            trans := 1.0 * fsize / duration.TotalSeconds;
            mult := '';
            if (trans > 1024) and (trans < 1024 * 1024) then begin
                trans := trans / 1024;
                mult := 'k';
            end else if trans > 1024 * 1024 then begin
                trans := trans / (1024 * 1024);
                mult := 'M';
            end;

            write(format(' (%d %sbytes/s)', [round(trans), mult]));
        end;
        writeln;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
